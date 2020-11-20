//
//  PostServiceProtocol.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 07/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

protocol PostServiceProtocol {
    var persistence: Persistence { get }
    var restClient: RestClientProtocol { get }
    var currentPostId: String? { get set }

    func getTopPostsFromServer(from subreddit: String, before: String?, after: String?, limit: Int?, count: Int?, onSuccess: ((([Post], Subreddit)) -> Void)?, onError: ((Error) -> Void)?)
    func getAll(conditions: [String : String]?, orderBy attributeNames: [String]?) -> [Post]
    func getEntityBy(id: String) -> Post?
}
