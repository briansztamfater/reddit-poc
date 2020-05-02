//
//  Logo+CoreDataClass.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 18/4/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import SwiftyJSON

public class Logo: PersistenceObject {
    
    var id: Int64?
    var small: String?
    var medium: String?
    var large: String?
    var sourceId: String?

    func updateWithJSON(_ json: JSON) {
        self.small = json["small"].stringValue
        self.medium = json["medium"].stringValue
        self.large = json["large"].stringValue
    }
}
