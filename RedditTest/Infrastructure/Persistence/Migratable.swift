//
//  Migratable.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 19/11/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import CoreData

protocol Migratable: Equatable {
    associatedtype Entity
    associatedtype Context

    static func build(from: Entity) -> Self?
    func export(to context: Context) throws -> Entity
}
