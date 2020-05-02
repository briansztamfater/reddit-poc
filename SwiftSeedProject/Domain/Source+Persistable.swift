//
//  Source+Persistable.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 22/10/2018.
//  Copyright © 2018 Brian Sztamfater. All rights reserved.
//

import GRDB

extension Source {
    
    public static let databaseTableName = "sources"
    
    public func didInsert(with rowID: String, for column: String?) {
        id = rowID
    }
}
