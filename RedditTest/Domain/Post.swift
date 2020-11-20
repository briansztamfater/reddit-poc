//
//  Post.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public struct Post: Codable {
    
    var id: String?
    var subreddit: String?
    var author: String?
    var title: String?
    var thumbnail: URL?
    var numComments: Int32
    var publishedAt: Date?
    var isVideo: Bool
    var wasViewed: Bool?
    var timestamp: Date?
    
    init(id: String, subreddit: String?, author: String, title: String, thumbnail: URL, numComments: Int32, publishedAt: Date?, isVideo: Bool, wasViewed: Bool?, timestamp: Date?) {
        self.id = id
        self.subreddit = subreddit
        self.author = author
        self.title = title
        self.thumbnail = thumbnail
        self.numComments = numComments
        self.publishedAt = publishedAt
        self.isVideo = isVideo
        self.wasViewed = wasViewed
        self.timestamp = timestamp
    }
//
    private enum CodingKeys: String, CodingKey {
        case id, author, title, subreddit, thumbnail, numComments, isVideo, wasViewed, timestamp
        case publishedAt = "createdUtc"
    }
//
//    private enum AdditionalCodingKeys: String, CodingKey {
//        case subreddit, wasViewed, timestamp
//    }
}

extension Post: Migratable {
    static func build(from entity: PostCoreDataEntity) -> Post? {
        guard let id = entity.id, let author = entity.author, let title = entity.title else {
            return nil
        }
//        guard let postSubreddit = entity.subreddit, let subreddit = Subreddit.build(from: postSubreddit) else{
//            return nil
//        }
        let thumbnail = entity.thumbnail
        let numComments = entity.numComments
        let isVideo = entity.isVideo
        let wasViewed = entity.wasViewed
        let publishedAt = entity.publishedAt
        let timestamp = entity.timestamp
        let subreddit = entity.subreddit
        return Post(id: id, subreddit: subreddit, author: author, title: title, thumbnail: (thumbnail ?? URL(string: "http://"))!, numComments: numComments, publishedAt: publishedAt, isVideo: isVideo, wasViewed: wasViewed, timestamp: timestamp)
    }

    func export(to context: NSManagedObjectContext) throws -> PostCoreDataEntity {
        let entity = PostCoreDataEntity(context: context)
        entity.id = id
        entity.subreddit = subreddit
        entity.author = author
        entity.title = title
        entity.thumbnail = thumbnail
        entity.numComments = numComments
        entity.publishedAt = publishedAt
        entity.isVideo = isVideo
        entity.wasViewed = wasViewed ?? false
        entity.timestamp = timestamp
        return entity
    }
}
