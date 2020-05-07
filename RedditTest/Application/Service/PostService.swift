//
//  PostService.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import Foundation

final class PostService: PostServiceProtocol {
    
    static let shared = PostService()
    
    @Inject internal var persistence: PersistenceProtocol
    @Inject internal var restClient: RestClientProtocol

    public var currentPostId: String?

    public func getTopPostsFromServer(from subreddit: String, before: String? = nil, after: String? = nil, limit: Int? = nil, count: Int? = nil, onSuccess: ((([Post], Subreddit)) -> Void)? = nil, onError: ((Error) -> Void)? = nil) {
        restClient.getTop(from: subreddit, before: before, after: after, limit: limit, count: count) { result in
            do {
                let result = try result.unwrap()
                let posts = result.0.map({ post -> Post in
                    let cachedPost = self.getEntityBy(id: post.id!)
                    post.wasViewed = cachedPost?.wasViewed
                    post.timestamp = cachedPost?.timestamp ?? post.timestamp
                    return post
                })
                let subreddit = result.1
                self.persistence.saveAll(objects: posts)
                self.persistence.save(object: subreddit)
                onSuccess?((posts, subreddit))
            } catch {
                onError?(error)
            }
        }
    }
    
    func getAll(conditions: [String : String]? = nil, orderBy attributeNames: [String]? = nil) -> [Post] {
        return persistence.getAll(conditions: conditions, orderBy: attributeNames)
    }
    
    func getEntityBy(id: String) -> Post? {
        return persistence.getBy(id: id)
    }
}
