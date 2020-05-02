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
            container.register(.singleton){ try PostService(persistence: container.resolve(), restClient: container.resolve() as RestClient) as PostService}

            // MARK: ViewModels
            container.register { try PostListViewModel(postService: container.resolve() as PostService) as PostListViewModel }

            // MARK: ViewControllers
            container.register(tag: "PostListVC") { PostListViewController() }
                .resolvingProperties { container, controller in
                    controller.viewModel = try container.resolve() as PostListViewModel
            }
            
            DependencyContainer.uiContainers = [container]

        }
    }
    
}
