//
//  PostDetailsViewModel.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Making Sense. All rights reserved.
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
        let post = postService.getEntityBy(id: postService.currentPostId!);
        title.accept(post!.title!)
        thumbnailUrl.accept(post!.thumbnailUrl!)
        author.accept(post!.author!)
        publishedAt.accept(post!.publishedAt!)
        self.postService = postService
    }
}
