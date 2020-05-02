//
//  Source+CoreDataClass.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 4/13/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

public class Source: PersistenceObject {
    
    var id: String?
    var url: URL?
    var detail: String?
    var name: String?
    var languageRaw: String?
    var countryRaw: String?
    var categoryRaw: String?

    init(_ json: JSON) {
        updateWithJSON(json)
    }
    
    func updateWithJSON(_ json: JSON) {
        self.id = json["id"].stringValue
        self.url = URL(string: json["url"].stringValue)!
        self.detail = json["description"].stringValue
        self.name = json["name"].stringValue
        self.categoryRaw = json["category"].stringValue
        self.languageRaw = json["language"].stringValue
        self.countryRaw = json["country"].stringValue
    }
}
