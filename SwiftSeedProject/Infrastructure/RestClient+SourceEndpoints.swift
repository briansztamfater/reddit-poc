//
//  RestClient+Source.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 21/4/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import Foundation
import SwiftyJSON

extension RestClient {
    
    func getSources(category: SourceCategory? = nil, language: Language? = nil, country: Country? = nil, completion: @escaping (DataResult<[Source]>) -> Void) {
        self.execute(target: NewsApiTarget.GetSources(category: category, language: language, country: country), completion: completion)  { json in
            return json["sources"].arrayValue.map { Source($0) }
        }
    }
}
