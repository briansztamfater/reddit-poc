//
//  RestClient+Article.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 21/4/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import Foundation
import SwiftyJSON

extension RestClient {
    
    func getArticles(source: Source, sortBy: String? = nil, completion: @escaping (DataResult<[Article]>) -> Void) {
        self.execute(target: NewsApiTarget.GetArticles(source: source, sortBy: sortBy), completion: completion) { json in
            return json["articles"].arrayValue.map { Article($0) }
        }
    }
}
