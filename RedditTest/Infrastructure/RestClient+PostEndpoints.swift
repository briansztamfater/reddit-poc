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
        self.execute(target: RedditTarget.GetTop(subreddit: subreddit, before: before, after: after, limit: limit, count: count), completion: completion) { data in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            guard let listingResponse = try? decoder.decode(ListingResponse<Post>.self, from: data) else {
              return nil
            }

            let subredditObject = Subreddit(title: subreddit, after: listingResponse.data.after)
            return ( listingResponse.data.children.map{ $0.data }, subredditObject )
        }
    }
}
