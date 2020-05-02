//
//  Logo+Persistable.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 22/10/2018.
//  Copyright © 2018 Brian Sztamfater. All rights reserved.
//

import GRDB

extension Logo {
    
    public static let databaseTableName = "logos"
    
    public func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
