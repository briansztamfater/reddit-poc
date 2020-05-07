//
//  PostModule.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 07/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import GRDB

protocol PostModuleType {
    func component() -> PostServiceProtocol
}

struct PostModule: PostModuleType {
    
    func component() -> PostServiceProtocol {
        PostService.shared
    }
}
