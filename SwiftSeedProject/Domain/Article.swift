//
//  Article+CoreDataClass.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 4/13/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

public class Article: PersistenceObject {
    
    var id: Int64?
    var sourceId: String?
    var author: String?
    var title: String?
    var detail: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: Date?

    init(_ json: JSON) {
        updateWithJSON(json)
    }
    
    func updateWithJSON(_ json: JSON) {
        self.title = json["title"].stringValue
        self.author = json["author"].stringValue
        self.detail = json["description"].stringValue
        self.url = json["url"].stringValue
        self.urlToImage = json["urlToImage"].stringValue
        self.publishedAt = DateUtils.parse(dateString: json["publishedAt"].stringValue)
    }
}
