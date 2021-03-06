//
//  Endpoint.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 3/4/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import Foundation

protocol Target {
    var baseUrl: URL { get }
    var apiKey: String? { get }
    var commonHeaders: [String : String]? { get }
    var method: String { get }
    var url: URL { get }
    var searchError: ([String : Any]) throws -> [String : Any] { get }
}
