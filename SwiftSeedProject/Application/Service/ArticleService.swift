//
//  ArticleService.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 4/13/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import Foundation

final class ArticleService: BaseService<Article> {
    
    public func getArticlesFromServer(by source: Source, onSuccess: (([Article]) -> Void)? = nil, onError: ((Error) -> Void)? = nil) {
        restClient.getArticles(source: source) { [weak self] result in
            guard let weakSelf = self else {
                return
            }
            do {
                let articles = try result.unwrap()
                articles.forEach { article in
                    article.sourceId = source.id
                }
                weakSelf.persistence.saveAll(objects: articles)
                onSuccess?(articles)
            } catch {
                onError?(error)
            }
        }
    }
}
