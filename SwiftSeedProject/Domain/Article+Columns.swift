//
//  Article+CoreDataProperties.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 4/13/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import GRDB

extension Article {
    
    // Define colums so that we can build GRDB requests
    enum Columns {
        static let id = Column("id")
    }
}
