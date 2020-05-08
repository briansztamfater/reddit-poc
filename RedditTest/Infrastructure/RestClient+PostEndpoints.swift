//
//  RestClient+PostEndpoints.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import Foundation

extension RestClient {
    
    func getTop(from subreddit: String, before: String? = nil, after: String? = nil, limit: Int? = nil, count: Int? = nil, completion: @escaping (DataResult<([Post], Subreddit)>) -> Void) {
        self.execute(target: RedditTarget.GetTop(subreddit: subreddit, before: before, after: after, limit: limit, count: count), completion: completion) { json in
            let data = json["data"] as! [String: Any]
            let children = data["children"] as! Array<[String: Any]>
            let subreddit = Subreddit(title: subreddit, after: data["after"] as? String)
            return ( children.map { Post($0["data"] as! [String: Any]) }, subreddit )
        }
    }
}
