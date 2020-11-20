//
//  RedditTestTests.swift
//  RedditTestTests
//
//  Created by Brian Sztamfater on 12/10/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import XCTest
@testable import RedditTest

class RedditTestTests: XCTestCase {

    func testPostViewModel_PostTitleShouldBeEqual() throws {
        let post = Post(id: "id", subreddit: "subreddit", author: "author", title: "title", thumbnail: URL(string: "http://")!, numComments: 1, publishedAt: Date(), isVideo: false, wasViewed: false, timestamp: Date())
        let postViewModel = PostViewModel(post: post)
        XCTAssertEqual(postViewModel.title, post.title)
    }
}
