//
//  GRDBPersistence.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 3/11/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import Foundation
import GRDB
import SwiftyJSON

class RGDBPersistence: PersistenceProtocol {
    
    static let NotificationTag = "%@EntityHasChanged"
    
    let db: DatabasePool
    
    init(databasePool: DatabasePool) {
        db = databasePool
    }
    
    public func getAll<T: PersistenceObject>(conditions: [String : String]?, orderBy attributeNames: [String]? = nil) -> [T] {
        do {
            let fetchedObjects = try db.read { db -> [T] in
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
                return try T.fetchAll(db, sql: sql)
            }
            return fetchedObjects
        } catch let error as NSError {
            fatalError("Failed to fetch object from \(T.databaseTableName): \(error)")
        }
    }
    
    public func getCustomBy<T: PersistenceObject>(attributeName: String, attributeValue: String) -> T? {
        do {
            let fetchedObject = try db.read { db -> T? in
                let sql = "SELECT * FROM \(T.databaseTableName) WHERE \(attributeName) = ?"
                return try T.fetchOne(db, sql: sql, arguments: [attributeValue])
            }
            return fetchedObject
        } catch let error as NSError {
            fatalError("Failed to fetch object from \(T.databaseTableName): \(error)")
        }
    }
    
    public func getByQuery<T: PersistenceObject>(_ query: String) -> [T]? {
        do {
            let fetchedObject = try db.read { db -> [T]? in
                return try T.fetchAll(db, sql: query)
            }
            return fetchedObject
        } catch let error as NSError {
            fatalError("Failed to fetch object from \(T.databaseTableName): \(error)")
        }
    }
    
    public func getBy<T: PersistenceObject>(id: Int64) -> T? {
        return getCustomBy(attributeName: "id", attributeValue: String(id))
    }
    
    public func getBy<T: PersistenceObject>(id: String) -> T? {
        return getCustomBy(attributeName: "id", attributeValue: id)
    }
    
    public func save<T: PersistenceObject>(object: T) {
        do {
            try db.writeInTransaction { db in
                try object.insert(db)
                return .commit
            }
            entityHasChanged(entity: T.databaseTableName, object: object)
        } catch let error as NSError {
            fatalError("Failed to save object on \(T.databaseTableName): \(error)")
        }
    }
    
    public func saveAll<T: PersistenceObject>(objects: [T]) {
        do {
            try db.writeInTransaction { db in
                try objects.forEach {
                    try $0.insert(db)
                }
                return .commit
            }
            entityHasChanged(entity: T.databaseTableName)
        } catch let error as NSError {
            fatalError("Failed to save objects on \(T.databaseTableName): \(error)")
        }
    }
    
    public func delete<T: PersistenceObject>(object: T) {
        do {
            try db.writeInTransaction { db in
                try object.delete(db)
                return .commit
            }
            entityHasChanged(entity: T.databaseTableName)
        } catch let error as NSError {
            fatalError("Failed to delete object on \(T.databaseTableName): \(error)")
        }
    }
    
    public func deleteAll<T: PersistenceObject>(objects: [T]) {
        do {
            try db.writeInTransaction { db in
                try objects.forEach {
                    try $0.delete(db)
                }
                return .commit
            }
            entityHasChanged(entity: T.databaseTableName)
        } catch let error as NSError {
            fatalError("Failed to delete objects on \(T.databaseTableName): \(error)")
        }
    }
    
    public func getNotificationTag(for entity: String) -> String {
        return String(format: RGDBPersistence.NotificationTag, entity)
    }
    
    private func entityHasChanged(entity: String, object: PersistenceObject? = nil) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: NSNotification.Name(rawValue: getNotificationTag(for: entity)), object: object)
    }
}
