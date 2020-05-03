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
        let cachedPosts = postService.getAll(conditions: nil, orderBy: ["timestamp"])
        posts.accept([SectionModel(model: "", items: cachedPosts.map { PostViewModel(post: $0) })])
    }
        
    public func selectPost(_ postViewModel: PostViewModel) {
        postViewModel.wasViewed.accept(true)
        let postId = postViewModel.identifier.value
        let post = postService.getEntityBy(id: postId)!
        post.wasViewed = true
        postService.persistence.save(object: post)
        postService.currentPostId = postId
        navigationDelegate?.navigate(SegueIdentifier.PostDetails)
    }
    
    public func getTopPosts() {
        postService.getTopPostsFromServer(from: "CryptoCurrencies", onSuccess: { [weak self] posts in
            guard let weakSelf = self else {
                return
            }
            weakSelf.posts.accept([SectionModel(model: "", items: weakSelf.postService.getAll(conditions: nil, orderBy: ["timestamp"]).map { PostViewModel(post: $0) })])
        })
    }
}
