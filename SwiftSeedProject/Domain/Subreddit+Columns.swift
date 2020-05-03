//
//  Subreddit+Columns.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Making Sense. All rights reserved.
//

import GRDB

extension Subreddit {

    // Define colums so that we can build GRDB requests
    enum Columns {
        static let id = Column("title")
    }
}
