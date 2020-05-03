//
//  Dictionary+Extensions.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 6/4/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import Foundation

public func += <K, V> ( left: inout [K : V], right: [K : V]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}
