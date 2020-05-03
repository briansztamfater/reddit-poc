//
//  SubredditService.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Making Sense. All rights reserved.
//

import Foundation

final class SubredditService: BaseService<Subreddit> {
    
    public func getSubreddit(title: String) -> Subreddit? {
        return persistence.getCustomBy(attributeName: "title", attributeValue: title)
    }
}
