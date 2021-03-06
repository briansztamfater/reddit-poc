//
//  PostDetailsViewModel.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import Combine
import Foundation

class PostDetailsViewModel: BaseViewModelProtocol {
    @Inject private var postModule: PostModuleType

    private lazy var postService: PostServiceProtocol = postModule.component()
    public weak var navigationDelegate: NavigationDelegate?

    @Published var title: String? = ""
    @Published var thumbnail = URL(string: "http://")!
    @Published var author: String? = ""
    @Published var publishedAt = Date()

    init() {
        if let currentPostId = postService.currentPostId, let post = postService.getEntityBy(id: currentPostId) {
            title = post.title!
            thumbnail = (post.thumbnail ?? URL(string: "http://"))!
            author = post.author!
            publishedAt = post.publishedAt ?? Date()
        }
    }
}
