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
                t.column("timestamp", .double)
            }
        }
        return migrator
    }
}
