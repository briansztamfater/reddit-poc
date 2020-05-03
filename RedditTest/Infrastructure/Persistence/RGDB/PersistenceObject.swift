//
//  PersistenceObject.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 3/11/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import GRDB
import SwiftyJSON

protocol PersistenceObject: Codable, PersistableRecord, FetchableRecord {
    func updateWithJSON(_ json: JSON)
}

extension PersistenceObject {
    func updateWithJSON(_ json: JSON) { }
}
