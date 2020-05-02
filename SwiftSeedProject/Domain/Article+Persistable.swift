//
//  Article+Persistable.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 22/10/2018.
//  Copyright © 2018 Brian Sztamfater. All rights reserved.
//

import GRDB

extension Article {
    
    public static let databaseTableName = "articles"
    
    public func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
