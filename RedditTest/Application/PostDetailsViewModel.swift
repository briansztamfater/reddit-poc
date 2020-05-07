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

class PostDetailsViewModel: BaseViewModelProtocol {
    @Inject private var postModule: PostModuleType

    private lazy var postService: PostServiceProtocol = postModule.component()
    public weak var navigationDelegate: NavigationDelegate?

    let title = BehaviorRelay<String>(value: "")
    let thumbnailUrl = BehaviorRelay<URL>(value: URL(string: "http://")!)
    let author = BehaviorRelay<String>(value: "")
    let publishedAt = BehaviorRelay<Date>(value: Date())

    init() {
        if let currentPostId = postService.currentPostId, let post = postService.getEntityBy(id: currentPostId) {
            title.accept(post.title!)
            thumbnailUrl.accept(post.thumbnailUrl!)
            author.accept(post.author!)
            publishedAt.accept(post.publishedAt!)
        }
    }
}
