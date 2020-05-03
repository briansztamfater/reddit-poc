//
//  Post+Columns.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import GRDB

extension Post {
    
    // Define colums so that we can build GRDB requests
    enum Columns {
        static let id = Column("id")
    }
}
