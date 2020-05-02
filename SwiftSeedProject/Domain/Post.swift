//
//  Post.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

public class Post: PersistenceObject {
    
    var id: String?
    var subreddit: String?
    var author: String?
    var title: String?
    var thumbnailUrl: URL?
    var numComments: Int?
    var publishedAt: Date?
    var isVideo: Bool?
    var wasViewed: Bool = false

    init(_ json: JSON) {
        updateWithJSON(json)
    }
    
    func updateWithJSON(_ json: JSON) {
        self.id = json["id"].stringValue
        self.title = json["title"].stringValue
        self.subreddit = json["subreddit"].stringValue
        self.author = json["author"].stringValue
        self.title = json["title"].stringValue
        self.thumbnailUrl = URL(string: json["thumbnail"].stringValue)!
        self.numComments = json["num_comments"].intValue
        self.publishedAt = Date(timeIntervalSince1970: json["created_utc"].doubleValue)
        self.isVideo = json["is_video"].boolValue
    }
}
