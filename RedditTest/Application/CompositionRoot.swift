//
//  CompositionRoot.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 4/5/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import GRDB

public final class CompositionRoot {
    
    static let dependencies = Dependencies {
        Module { RGDBPersistence(databasePool: try! Database.openDatabase() as DatabasePool) as PersistenceProtocol }
        Module { RestClient() as RestClientProtocol }
        Module { PostModule() as PostModuleType }
        Module { SubredditModule() as SubredditModuleType }
        Module { PostListViewModel() as PostListViewModel }
        Module { PostDetailsViewModel() as PostDetailsViewModel }
    }
}
