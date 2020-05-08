//
//  PostListViewModel.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import Foundation

class PostListViewModel: BaseViewModelProtocol {
    @Inject private var postModule: PostModuleType
    @Inject private var subredditModule: SubredditModuleType

    private lazy var postService: PostServiceProtocol = postModule.component()
    private lazy var subredditService: SubredditServiceProtocol = subredditModule.component()
    public weak var navigationDelegate: NavigationDelegate?

    let subreddit = "CryptoCurrencies" // We could support multiple subreddits but let's hardcode this one for this test
    let pageSize = 10 // We could make this value configurable but let's hardcode this one for this test
    @Published var posts: [PostViewModel] = []
    @Published var isLoading = false
    
    var shouldLoad: Bool = false
    var lastItem: String? = nil

    init() {
        let subreddit = subredditService.getSubreddit(title: self.subreddit)
        self.lastItem = subreddit?.after
        self.shouldLoad = self.lastItem != nil
        let cachedPosts = postService.getAll(conditions: nil, orderBy: ["rowid"])
        posts = cachedPosts.map { PostViewModel(post: $0) }
        if subreddit == nil {
            getTopPosts(forceLoad: true)
        }
    }
        
    public func selectPost(at index: Int) {
        let postViewModel = posts[index]
        postViewModel.wasViewed = true
        let postId = postViewModel.identifier
        let post = postService.getEntityBy(id: postId)!
        post.wasViewed = true
        postService.persistence.save(object: post)
        postService.currentPostId = postId
        navigationDelegate?.navigate(SegueIdentifier.PostDetails)
    }
    
    public func deletePost(at index: Int) {
        let postViewModel = posts[index]
        posts.remove(at: index)
        let postId = postViewModel.identifier
        let post = postService.getEntityBy(id: postId)!
        postService.persistence.delete(object: post)
    }
    
    public func deletePost(from viewModel: PostViewModel) {
        let postIndex = posts.firstIndex{ $0.identifier == viewModel.identifier }!
        deletePost(at: postIndex)
    }
    
    public func deleteAll() {
        if (posts.count > 0) {
            posts = []
            let posts = postService.getAll(conditions: nil, orderBy: nil)
            postService.persistence.deleteAll(objects: posts)
            if let subreddit = subredditService.getSubreddit(title: self.subreddit) {
                subredditService.persistence.delete(object: subreddit)
            }
            self.lastItem = nil
            self.shouldLoad = true
        }
    }

    public func getTopPosts(forceLoad: Bool = false) {
        if !isLoading && (shouldLoad || forceLoad) {
            isLoading = true
            postService.getTopPostsFromServer(from: subreddit, before: nil, after: lastItem, limit: pageSize, count: nil, onSuccess: { [weak self] posts in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.posts = weakSelf.postService.getAll(conditions: nil, orderBy: ["rowid"]).map { PostViewModel(post: $0) }
                weakSelf.lastItem = posts.1.after
                weakSelf.shouldLoad = posts.1.after != nil && posts.1.after!.count > 0
                weakSelf.isLoading = false
            }, onError: nil)
        }
    }
    
    public func refreshAll() {
        if !isLoading {
            posts = []
            let posts = postService.getAll(conditions: nil, orderBy: nil)
            postService.persistence.deleteAll(objects: posts)
            if let subreddit = subredditService.getSubreddit(title: self.subreddit) {
                subredditService.persistence.delete(object: subreddit)
            }
            self.lastItem = nil
            self.shouldLoad = true
            self.getTopPosts()
        }
    }
}
