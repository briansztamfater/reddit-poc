//
//  SubredditModule.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 07/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import GRDB

protocol SubredditModuleType {
    func component() -> SubredditServiceProtocol
}

struct SubredditModule: SubredditModuleType {
    
    func component() -> SubredditServiceProtocol {
        SubredditService()
    }
}
