//
//  PostService.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import Foundation

final class PostService: BaseService<Post> {
    
    public var currentPostId: String?

    public func getTopPostsFromServer(from subreddit: String, before: String? = nil, after: String? = nil, limit: Int? = nil, count: Int? = nil, onSuccess: ((([Post], Subreddit)) -> Void)? = nil, onError: ((Error) -> Void)? = nil) {
        restClient.getTop(from: subreddit, before: before, after: after, limit: limit, count: count) { [weak self] result in
            guard let weakSelf = self else {
                return
            }
            do {
                let result = try result.unwrap()
                let posts = result.0.map({ post -> Post in
                    let cachedPost = weakSelf.getEntityBy(id: post.id!)
                    post.wasViewed = cachedPost?.wasViewed
                    post.timestamp = cachedPost?.timestamp ?? post.timestamp
                    return post
                })
                let subreddit = result.1
                weakSelf.persistence.saveAll(objects: posts)
                weakSelf.persistence.save(object: subreddit)
                onSuccess?((posts, subreddit))
            } catch {
                onError?(error)
            }
        }
    }
}
