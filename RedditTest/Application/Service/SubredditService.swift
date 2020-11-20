//
//  SubredditService.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import Foundation

struct SubredditService: SubredditServiceProtocol {
    @Inject internal var persistence: Persistence

    public func getSubreddit(title: String) -> Subreddit? {
        return persistence.getCustomBy(attributeName: "title", attributeValue: title)
    }
}
