//
//  PersistenceObject.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 3/11/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import SwiftyJSON

protocol PersistenceObject {
    static var databaseTableName: String { get }
    static var databaseIdentifierColumn: String { get }

    init()
    func updateWithJSON(_ json: JSON)
    func updateWithDictionary(_ dictionary: Dictionary<String, String?>)
    func dbRepresentationDict() -> Dictionary<String, Any?>
    func databaseIdentifier() -> Any
}

extension PersistenceObject {
    func updateWithJSON(_ json: JSON) { }
    func updateWithDictionary(_ dictionary: Dictionary<String, String?>) { }
}
