//
//  Subreddit.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import CoreData
import UIKit

public struct Subreddit: Codable {

    var title: String?
    var after: String?
    
    init(title: String, after: String?) {
        self.title = title
        self.after = after
    }
}

extension Subreddit: Migratable {

    static func build(from entity: SubredditCoreDataEntity) -> Subreddit? {
        guard let title = entity.title, let after = entity.after else {
            return nil
        }
        return Subreddit(title: title, after: after)
    }

    func export(to context: NSManagedObjectContext) throws -> SubredditCoreDataEntity {
        let entity = SubredditCoreDataEntity(context: context)
        entity.title = self.title
        entity.after = self.after
        return entity
    }
}
