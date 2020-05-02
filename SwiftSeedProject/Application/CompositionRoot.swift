//
//  CompositionRoot.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 4/5/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import Dip
import GRDB

extension DependencyContainer {
    
    // TODO: Create protocol dependencies
    static func configure() -> DependencyContainer {
        return DependencyContainer { container in

            // MARK: Persistence
            container.register(.singleton) { try! Database.openDatabase() as DatabasePool }
            container.register(.singleton) { RGDBPersistence(databasePool: try! container.resolve()) as Persistence }
            
            // MARK: Network
            container.register(.singleton) { RestClient() as RestClient }

            // MARK: Services
            container.register(.singleton){ try ArticleService(persistence: container.resolve(), restClient: container.resolve() as RestClient) as ArticleService}
            container.register(.singleton){ try SourceService(persistence: container.resolve(), restClient: container.resolve() as RestClient) as SourceService}
            
            // MARK: ViewModels
            container.register { try SourceListViewModel(sourceService: container.resolve() as SourceService) as SourceListViewModel }
            container.register { try NewsFeedViewModel(articleService: container.resolve() as ArticleService, sourceService: container.resolve() as SourceService) as NewsFeedViewModel }

            // MARK: ViewControllers
            container.register(tag: "SourceListVC") { SourceListViewController() }
                .resolvingProperties { container, controller in
                    controller.viewModel = try container.resolve() as SourceListViewModel
            }
            
            container.register(tag: "NewsFeedCollectionViewController") { NewsFeedCollectionViewController() }
                .resolvingProperties { container, controller in
                    controller.viewModel = try container.resolve() as NewsFeedViewModel
            }
            
            DependencyContainer.uiContainers = [container]

        }
    }
    
}
