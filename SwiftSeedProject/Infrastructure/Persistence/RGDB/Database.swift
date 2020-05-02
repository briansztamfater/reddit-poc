//
//  Database.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 8/11/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import GRDB

public class Database {
    
    static var databasePath: String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        return documentsPath.appendingPathComponent("db.sqlite")
    }
    
    static func openDatabase(atPath path: String? = databasePath) throws -> DatabasePool {
        let dbPool = try DatabasePool(path: path!)
        try migrator.migrate(dbPool)
        return dbPool
    }
    
    static var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        migrator.registerMigration("v1.0") { db in
            try db.create(table: "posts") { t in
                t.column("id", .text).primaryKey(onConflict: .replace)
                t.column("subreddit", .text)
                t.column("title", .text)
                t.column("author", .text)
                t.column("thumbnailUrl", .text)
                t.column("numComments", .integer)
                t.column("isVideo", .boolean)
                t.column("publishedAt", .datetime)
                t.column("wasViewed", .boolean)
            }
            try db.create(table: "sources") { t in
                t.column("id", .text).primaryKey(onConflict: .replace)
                t.column("url", .text)
                t.column("detail", .text)
                t.column("name", .text)
                t.column("categoryRaw", .text)
                t.column("languageRaw", .text)
                t.column("countryRaw", .text)
                t.column("sortByAvailable", .text)
            }
            try db.create(table: "articles") { t in
                t.column("id", .integer).primaryKey(onConflict: .replace)
                t.column("sourceId", .integer)
                t.column("title", .text)
                t.column("author", .text)
                t.column("detail", .text)
                t.column("url", .text)
                t.column("urlToImage", .text)
                t.column("publishedAt", .datetime)
            }
            try db.create(table: "logos") { t in
                t.column("id", .integer).primaryKey(onConflict: .replace)
                t.column("sourceId", .integer).unique(onConflict: .replace)
                t.column("small", .text)
                t.column("medium", .text)
                t.column("large", .text)
            }
        }
        return migrator
    }
}
