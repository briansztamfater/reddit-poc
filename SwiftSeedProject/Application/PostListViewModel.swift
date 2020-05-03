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
    private let subredditService: SubredditService!

    let subreddit = "CryptoCurrencies" // We could support multiple subreddits but let's hardcode this one for this test
    let pageSize = 10 // We could make this value configurable but let's hardcode this one for this test
    let posts = BehaviorRelay<[AnimatableSectionModel<String, PostViewModel>]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    var shouldLoad: Bool = false
    var lastItem: String? = nil

    init(postService: PostService, subredditService: SubredditService) {
        self.postService = postService
        self.subredditService = subredditService
        let subreddit = subredditService.getSubreddit(title: self.subreddit)
        self.lastItem = subreddit?.after
        let cachedPosts = postService.getAll(conditions: nil, orderBy: ["timestamp"])
        self.shouldLoad = cachedPosts.count == 0
        posts.accept([AnimatableSectionModel(model: "", items: cachedPosts.map { PostViewModel(post: $0) })])
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
    
    public func deletePost(at index: Int) {
        var sections = posts.value
        var currentSection = sections[0]
        let postViewModel = currentSection.items[index]
        currentSection.items.remove(at: index)
        sections[0] = currentSection
        posts.accept(sections)
        let postId = postViewModel.identifier.value
        let post = postService.getEntityBy(id: postId)!
        postService.persistence.delete(object: post)
    }
    
    public func deletePost(from viewModel: PostViewModel) {
        let sections = posts.value
        let currentSection = sections[0]
        let postIndex = currentSection.items.firstIndex(of: viewModel)!
        deletePost(at: postIndex)
    }
    
    public func getTopPosts(forceLoad: Bool = false) {
        if !isLoading.value && (shouldLoad || forceLoad) {
            isLoading.accept(true)
            postService.getTopPostsFromServer(from: subreddit, after: lastItem, limit: pageSize, onSuccess: { [weak self] posts in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.posts.accept([AnimatableSectionModel(model: "", items: weakSelf.postService.getAll(conditions: nil, orderBy: ["timestamp"]).map { PostViewModel(post: $0) })])
                weakSelf.lastItem = posts.1.after
                weakSelf.isLoading.accept(false)
            })
        }
    }
    
    public func refreshAll() {
        if !isLoading.value {
            posts.accept([])
            let posts = postService.getAll()
            let subreddit = subredditService.getSubreddit(title: self.subreddit)
            postService.persistence.deleteAll(objects: posts)
            subredditService.persistence.delete(object: subreddit!)
            self.lastItem = nil
            self.shouldLoad = true
            self.getTopPosts()
        }
    }
}
