//
//  Persistence.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 3/11/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

protocol Persistence: class {
    func getAll<T: Migratable>(conditions: [String : String]?, orderBy attributeNames: [String]?) -> [T] // TODO: Allow multiple conditions types and ascending or descending order
    func getBy<T: Migratable>(id: Int64) -> T?
    func getBy<T: Migratable>(id: String) -> T?
    func getCustomBy<T: Migratable>(attributeName: String, attributeValue: String) -> T?
    func save<T: Migratable>(object: T)
    func saveAll<T: Migratable>(objects: [T])
    func delete<T: Migratable>(object: T)
    func deleteAll<T: Migratable>(objects: [T])
}

extension Persistence {
    func getAll<T: Migratable>(conditions: [String : String]? = nil, orderBy attributeNames: [String]? = nil) -> [T] {
        return getAll(conditions: conditions, orderBy: attributeNames)
    }
}
