//
//  ArticleViewModel.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 4/18/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ArticleViewModel {
    
    var imageUrl: Variable<String>
    var date: Variable<Date?>
    var description: Variable<String>
    var title: Variable<String>
    var author: Variable<String>
    var sourceURL: Variable<String>
    
    init(article: Article) {
        self.imageUrl = Variable(article.urlToImage!)
        self.date = Variable(article.publishedAt)
        self.description = Variable(article.detail!)
        self.title = Variable(article.title!)
        self.author = Variable(article.author!)
        self.sourceURL = Variable(article.url!)
    }
}
