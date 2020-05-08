//
//  Post.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Post: PersistenceObject {
    
    public static let databaseTableName = "posts"
    public static let databaseIdentifierColumn = "id"

    var id: String?
    var subreddit: String?
    var author: String?
    var title: String?
    var thumbnailUrl: URL?
    var numComments: Int?
    var publishedAt: Date?
    var isVideo: Bool?
    var wasViewed: Bool?
    var timestamp: Double?

    required init() {}
    
    init(_ json: JSON) {
        updateWithJSON(json)
    }
    
    func updateWithJSON(_ json: JSON) {
        self.id = json["id"].stringValue
        self.title = json["title"].stringValue
        self.subreddit = json["subreddit"].stringValue
        self.author = json["author"].stringValue
        self.thumbnailUrl = URL(string: json["thumbnail"].stringValue)!
        self.numComments = json["num_comments"].intValue
        self.publishedAt = Date(timeIntervalSince1970: json["created_utc"].doubleValue)
        self.isVideo = json["is_video"].boolValue
        self.timestamp = Double(Date().timeIntervalSince1970)
    }
    
    func updateWithDictionary(_ dictionary: Dictionary<String, String?>) {
        id = dictionary["id"] ?? nil
        title = dictionary["title"] ?? nil
        subreddit = dictionary["subreddit"] ?? nil
        author = dictionary["author"] ?? nil
        thumbnailUrl = URL(string: (dictionary["thumbnailUrl"] ?? "https://")!)!
        numComments = dictionary["numComments"]! != nil ? (dictionary["numComments"]!! as NSString).integerValue : 0
        publishedAt = dictionary["publishedAt"]! != nil ? Date(timeIntervalSince1970: (dictionary["publishedAt"]!! as NSString).doubleValue) : nil
        isVideo = dictionary["isVideo"]! != nil ? (dictionary["isVideo"]!! as NSString).boolValue : nil
        wasViewed = dictionary["wasViewed"] != nil && dictionary["wasViewed"]! != nil ? (dictionary["wasViewed"]!! as NSString).boolValue : nil
        timestamp = dictionary["timestamp"]! != nil ? (dictionary["numComments"]!! as NSString).doubleValue : nil
    }
    
    func dbRepresentationDict() -> Dictionary<String, Any?> {
        return [
            "id": id,
            "title": title,
            "subreddit": subreddit,
            "author": author,
            "thumbnailUrl": thumbnailUrl!.absoluteString,
            "numComments": numComments,
            "publishedAt": publishedAt!.timeIntervalSince1970,
            "isVideo": isVideo,
            "wasViewed": wasViewed,
            "timestamp": timestamp
        ]
    }
    
    func databaseIdentifier() -> Any {
        return id as Any
    }
}
