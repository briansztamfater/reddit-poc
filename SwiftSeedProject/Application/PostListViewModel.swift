//
//  PostListViewModel.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Making Sense. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

class PostListViewModel: ViewModelBase {
    
    private let postService: PostService!

    let posts = BehaviorRelay<[SectionModel<String, PostViewModel>]>(value: [])
    
    init(postService: PostService) {
        self.postService = postService
    }
        
    public func selectPost(_ postViewModel: PostViewModel) {
        postService.currentPostId = postViewModel.identifier.value
        navigationDelegate?.navigate(SegueIdentifier.NewsFeed)
    }
    
    public func getTopPosts() {
        postService.getTopPostsFromServer(from: "CryptoCurrencies", onSuccess: { [weak self] posts in
            guard let weakSelf = self else {
                return
            }
            weakSelf.posts.accept([SectionModel(model: "", items: weakSelf.postService.getAll().map { PostViewModel(post: $0) })])
        })
    }
}
