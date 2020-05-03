//
//  NewsApiEndpoint.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 20/4/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import Foundation
import SwiftyJSON

enum RedditTarget: Target {
    
    var baseUrl: URL { return URL(string: "https://www.reddit.com")! }
    var apiKey: String? { return "" }
    // Insert your common headers here, for example, authorization token or accept.
    var commonHeaders: [String : String]? { return [:] }
    
    case GetTop(subreddit: String, before: String?, after: String?, limit: Int?, count: Int?)
    
    // MARK: - Public Properties
    var method: String {
        switch self {
        case .GetTop:
            return "GET"
        }
    }
    
    var url: URL {
        switch self {
            case .GetTop(let subreddit, let before, let after, let limit, let count):
                let url = baseUrl.appendingPathComponent("r").appendingPathComponent(subreddit).appendingPathComponent("top.json")
                var parameters = "?"
                if let before = before {
                    parameters += "before=\(before)"
                }
                if let after = after {
                    parameters += parameters.count > 1 ? "&" : ""
                    parameters += "after=\(after)"
                }
                if let limit = limit {
                    parameters += parameters.count > 1 ? "&" : ""
                    parameters += "limit=\(limit)"
                }
                if let count = count {
                    parameters += parameters.count > 1 ? "&" : ""
                    parameters += "count=\(count)"
                }
                return URL(string: parameters, relativeTo: url)!
        }
    }
    
    var errorSanitizer: (JSON) throws -> JSON {
        return { json in return json }
    }
}
