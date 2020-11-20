//
//  PostViewModel.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import Foundation

class PostViewModel {
    @Published var identifier: String
    @Published var title: String
    @Published var thumbnail: URL
    @Published var author: String
    @Published var subreddit: String
    @Published var numComments: Int32
    @Published var publishedAt: Date
    @Published var isVideo: Bool
    @Published var wasViewed: Bool

    init(post: Post) {
        self.identifier = post.id!
        self.title = post.title!
        self.thumbnail = (post.thumbnail ?? URL(string: "http://"))!
        self.author = post.author!
        self.subreddit = post.subreddit ?? ""
        self.numComments = post.numComments
        self.publishedAt = post.publishedAt ?? Date()
        self.isVideo = post.isVideo
        self.wasViewed = post.wasViewed ?? false
    }
}
