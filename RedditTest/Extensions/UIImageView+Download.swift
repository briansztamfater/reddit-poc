//
//  UIImageView+Download.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 08/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(withUrl url: URL) {
        if let imageFromCache = UIImage.imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        UIImage.cacheImage(from: url) { [weak self] image in
            guard let weakSelf = self, let imageFromCache = image else {
                return
            }
            weakSelf.image = imageFromCache
        }
    }
}
