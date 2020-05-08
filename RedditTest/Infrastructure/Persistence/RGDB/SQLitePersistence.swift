//
//  SQLitePersistence.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 3/11/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import Foundation
import SQLite3

class SQLitePersistence: PersistenceProtocol {
    
    static let NotificationTag = "%@EntityHasChanged"
    
    let dbPath: String = "db.sqlite"
    var db: OpaquePointer?

    init() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        } else {
            print("Successfully opened connection to database at \(dbPath)")
            self.db = db
        }
        createTable()
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS posts (id TEXT PRIMARY KEY, subreddit TEXT, title TEXT, author TEXT, thumbnailUrl TEXT, numComments INTEGER, isVideo BOOLEAN, publishedAt DATETIME, wasViewed BOOLEAN, timestamp DOUBLE); CREATE TABLE IF NOT EXISTS subreddit (title TEXT PRIMARY KEY, after TEXT)"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Tables created.")
            } else {
                print("Tables could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    public func getAll<T: PersistenceObject>(conditions: [String : String]?, orderBy attributeNames: [String]? = nil) -> [T] {
        var sql = "SELECT * FROM \(T.databaseTableName)"
        if let conditions = conditions {
            sql += " WHERE "
            for (index, element) in conditions.enumerated() {
                sql += "\(element.key) = \(element.value)"
                if index < attributeNames!.count - 1 {
                    sql += " AND "
                }
            }
        }
        if let attributeNames = attributeNames {
            sql += " ORDER BY "
            for (index, element) in attributeNames.enumerated() {
                sql += element
                sql += " ASC"
                if index < attributeNames.count - 1 {
                    sql += ", "
                }
            }
        }
        var queryStatement: OpaquePointer? = nil
        var fetchedObjects: [T] = []
        if sqlite3_prepare_v2(db, sql, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                var dictionary: Dictionary<String, String?> = [:]
                for i in 0...sqlite3_column_count(queryStatement) - 1 {
                    let column: String = String(cString: sqlite3_column_name(queryStatement, i))
                    let rawValue = sqlite3_column_text(queryStatement, i)
                    let value: String? = (rawValue != nil) ? String(cString: rawValue!) : nil
                    dictionary[column] = value
                }
                let object = T.init()
                object.updateWithDictionary(dictionary)
                fetchedObjects.append(object)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return fetchedObjects
    }
    
    public func getCustomBy<T: PersistenceObject>(attributeName: String, attributeValue: String) -> T? {
        let sql = "SELECT * FROM \(T.databaseTableName) WHERE \(attributeName) = ?"
        var queryStatement: OpaquePointer? = nil
        var fetchedObject: T? = nil
        if sqlite3_prepare_v2(db, sql, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (attributeValue as NSString).utf8String, -1, nil)
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                var dictionary: Dictionary<String, String> = [:]
                for i in 0...sqlite3_column_count(queryStatement) - 1 {
                    let column: String = String(cString: sqlite3_column_name(queryStatement, i))
                    let rawValue = sqlite3_column_text(queryStatement, i)
                    let value: String? = (rawValue != nil) ? String(cString: rawValue!) : nil
                    dictionary[column] = value
                }
                let object = T.init()
                object.updateWithDictionary(dictionary)
                fetchedObject = object
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return fetchedObject
    }
    
    public func getByQuery<T: PersistenceObject>(_ query: String) -> [T]? {
        var queryStatement: OpaquePointer? = nil
        var fetchedObjects: [T]? = nil
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            fetchedObjects = []
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                var dictionary: Dictionary<String, String> = [:]
                for i in 0...sqlite3_column_count(queryStatement) - 1 {
                    let column: String = String(cString: sqlite3_column_name(queryStatement, i))
                    let value: String = String(cString: sqlite3_column_text(queryStatement, i))
                    dictionary[column] = value
                    let object = T.init()
                    object.updateWithDictionary(dictionary)
                    fetchedObjects!.append(object)
                }
            }
        } else {
            print("Custom statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return fetchedObjects
    }
    
    public func getBy<T: PersistenceObject>(id: Int64) -> T? {
        return getCustomBy(attributeName: T.databaseIdentifierColumn, attributeValue: String(id))
    }
    
    public func getBy<T: PersistenceObject>(id: String) -> T? {
        return getCustomBy(attributeName: T.databaseIdentifierColumn, attributeValue: id)
    }
    
    public func save<T: PersistenceObject>(object: T) {
        let objectDict = object.dbRepresentationDict()
        var sql = ""
        if let objectIdentifier = objectDict[T.databaseIdentifierColumn] {
            var savedObject: T? = nil
            if objectIdentifier is String {
                savedObject = self.getBy(id: objectIdentifier as! String)
            } else {
                savedObject = self.getBy(id: objectIdentifier as! Int64)
            }
            if (savedObject != nil) {
                sql = "UPDATE \(T.databaseTableName)"
                sql += " SET "
                var values = ""
                for (key, value) in objectDict {
                    if (values.count > 0) {
                        values += ", "
                    }
                    values += key
                    values += " = "
                    if let value = value {
                        values += value is String ? "\"\(value)\"" : "\(value)"
                    } else {
                        values += "NULL"
                    }
                }
                sql += values
                sql += " WHERE \(T.databaseIdentifierColumn) = "
                sql += objectIdentifier is String ? "\"\(objectIdentifier!)\"" : "\(objectIdentifier!)"
            }
        }
        if (sql.count == 0) {
            sql = "INSERT INTO \(T.databaseTableName) ("
            var columns = ""
            for (key) in Array(objectDict.keys) {
                if (columns.count > 0) {
                    columns += ", "
                }
                columns += key
            }
            sql += columns
            sql += ") "
            sql += "VALUES"
            sql += " ("
            var values = ""
            for (value) in objectDict.values {
                if (values.count > 0) {
                    values += ", "
                }
                if let value = value {
                    values += value is String ? "\"\(value)\"" : "\(value)"
                } else {
                    values += "NULL"
                }
            }
            sql += values
            sql += ")"
        }
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sql, -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
                entityHasChanged(entity: T.databaseTableName, object: object)
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT or UPDATE statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    public func saveAll<T: PersistenceObject>(objects: [T]) {
        objects.forEach { save(object: $0) }
    }
    
    public func delete<T: PersistenceObject>(object: T) {
        let deleteStatementString = "DELETE FROM \(T.databaseTableName) WHERE \(T.databaseIdentifierColumn) = ?"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            let identifier = object.databaseIdentifier()
            if identifier is String {
                sqlite3_bind_text(deleteStatement, 1, (identifier as! NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_int(deleteStatement, 1, Int32(identifier as! Int))
            }
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
        entityHasChanged(entity: T.databaseTableName)
    }
    
    public func deleteAll<T: PersistenceObject>(objects: [T]) {
        objects.forEach { delete(object: $0) }
    }
    
    public func getNotificationTag(for entity: String) -> String {
        return String(format: SQLitePersistence.NotificationTag, entity)
    }
    
    private func entityHasChanged(entity: String, object: PersistenceObject? = nil) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: NSNotification.Name(rawValue: getNotificationTag(for: entity)), object: object)
    }
}
