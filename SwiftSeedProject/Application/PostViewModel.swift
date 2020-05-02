//
//  PostViewModel.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Making Sense. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PostViewModel {
    let identifier: BehaviorRelay<String>
    let title: BehaviorRelay<String>
    let thumbnailUrl: BehaviorRelay<URL>
    let author: BehaviorRelay<String>
    let subreddit: BehaviorRelay<String>
    let numComments: BehaviorRelay<Int>
    let publishedAt: BehaviorRelay<Date>
    let isVideo: BehaviorRelay<Bool>
    let wasViewed: BehaviorRelay<Bool>

    init(post: Post) {
        self.identifier = BehaviorRelay<String>(value: post.id!)
        self.title = BehaviorRelay<String>(value: post.title!)
        self.thumbnailUrl = BehaviorRelay<URL>(value: post.thumbnailUrl!)
        self.author = BehaviorRelay<String>(value: post.author!)
        self.subreddit = BehaviorRelay<String>(value: post.subreddit!)
        self.numComments = BehaviorRelay<Int>(value: post.numComments!)
        self.publishedAt = BehaviorRelay<Date>(value: post.publishedAt!)
        self.isVideo = BehaviorRelay<Bool>(value: post.isVideo!)
        self.wasViewed = BehaviorRelay<Bool>(value: post.wasViewed)
    }
}
