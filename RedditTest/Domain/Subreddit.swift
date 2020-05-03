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
    
    var title: String?
    var after: String?
    
    init(title: String, after: String?) {
        self.title = title
        self.after = after
    }
}
