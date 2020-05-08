//
//  Subreddit.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Subreddit: PersistenceObject {
    
    public static let databaseTableName = "subreddit"
    public static let databaseIdentifierColumn = "title"

    var title: String?
    var after: String?
    
    required init() {}

    init(title: String, after: String?) {
        self.title = title
        self.after = after
    }
    
    func updateWithDictionary(_ dictionary: Dictionary<String, String?>) {
        title = dictionary["title"] ?? nil
        after = dictionary["after"] ?? nil
    }
    
    func dbRepresentationDict() -> Dictionary<String, Any?> {
        return [
            "title": title,
            "after": after,
        ]
    }
    
    func databaseIdentifier() -> Any {
        return title as Any
    }
}
