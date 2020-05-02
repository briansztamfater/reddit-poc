//
//  NewsFeedViewModel.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 4/21/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

class NewsFeedViewModel {
    
    private let articleService: ArticleService!
    private let sourceService: SourceService!
    
    let newsArticles = Variable<[SectionModel<String, ArticleViewModel>]>([])
    
    init(articleService: ArticleService, sourceService: SourceService) {
        self.articleService = articleService
        self.sourceService = sourceService
    }
    
    public func getArticles() {
        let source = sourceService.getEntityBy(id: sourceService.currentSourceId!)!
        articleService.getArticlesFromServer(by: source, onSuccess: { [weak self] articles in
            guard let weakSelf = self else {
                return
            }
            weakSelf.newsArticles.value = [SectionModel(model: "", items: articles.map { ArticleViewModel(article: $0 ) })]
        })
    }
}
