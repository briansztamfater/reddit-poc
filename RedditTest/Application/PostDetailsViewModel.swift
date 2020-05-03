//
//  PostDetailsViewModel.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

class PostDetailsViewModel: ViewModelBase {
    
    private let postService: PostService!

    let title = BehaviorRelay<String>(value: "")
    let thumbnailUrl = BehaviorRelay<URL>(value: URL(string: "http://")!)
    let author = BehaviorRelay<String>(value: "")
    let publishedAt = BehaviorRelay<Date>(value: Date())

    init(postService: PostService) {
        if let currentPostId = postService.currentPostId, let post = postService.getEntityBy(id: currentPostId) {
            title.accept(post.title!)
            thumbnailUrl.accept(post.thumbnailUrl!)
            author.accept(post.author!)
            publishedAt.accept(post.publishedAt!)
        }
        self.postService = postService
    }
}
