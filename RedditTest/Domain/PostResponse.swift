//
//  PostResponse.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 20/11/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import Foundation

struct ListingResponse<T: Codable>: Codable {
    struct Payload: Codable {
        let children: [Item]
        let after: String?
        let before: String?
    }
    
    struct Item: Codable {
        let data: T
    }

    let data: Payload
}
