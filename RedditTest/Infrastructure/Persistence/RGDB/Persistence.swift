//
//  Persistence.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 3/11/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import GRDB
import SwiftyJSON

protocol Persistence {
    func getAll<T: PersistenceObject>(conditions: [String : String]?, orderBy attributeNames: [String]?) -> [T] // TODO: Allow multiple conditions types and ascending or descending order
    func getBy<T: PersistenceObject>(id: Int64) -> T?
    func getBy<T: PersistenceObject>(id: String) -> T?
    func getCustomBy<T: PersistenceObject>(attributeName: String, attributeValue: String) -> T?
    func save<T: PersistenceObject>(object: T)
    func saveAll<T: PersistenceObject>(objects: [T])
    func delete<T: PersistenceObject>(object: T)
    func deleteAll<T: PersistenceObject>(objects: [T])
    func getNotificationTag(for entity: String) -> String
}

extension Persistence {
    func getAll<T: PersistenceObject>(conditions: [String : String]? = nil, orderBy attributeNames: [String]? = nil) -> [T] {
        return getAll(conditions: conditions, orderBy: attributeNames)
    }
}
