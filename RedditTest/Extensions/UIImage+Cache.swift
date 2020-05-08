//
//  UIImage+Cache.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 08/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static let imageCache = NSCache<NSString, AnyObject>()
    
    static func cacheImage(from url: URL, completion: @escaping (UIImage?) -> ()) {
        if let imageData = try? Data(contentsOf: url) {
           if let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                }
                completion(image)
           }
        }
    }
}
