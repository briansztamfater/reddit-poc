//
//  SubredditServiceProtocol.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 07/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

protocol SubredditServiceProtocol {
    var persistence: Persistence { get }
    
    func getSubreddit(title: String) -> Subreddit?
}
