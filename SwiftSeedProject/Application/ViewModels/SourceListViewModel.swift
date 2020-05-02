//
//  ViewModel.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 27/3/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

class SourceListViewModel: ViewModelBase {
    
    private let sourceService: SourceService!
    
    let sources = Variable<[SectionModel<String, SourceViewModel>]>([])
    
    init(sourceService: SourceService) {
        self.sourceService = sourceService
    }
        
    public func selectSource(_ sourceViewModel: SourceViewModel) {
        sourceService.currentSourceId = sourceViewModel.identifier.value
        navigationDelegate?.navigate(SegueIdentifier.NewsFeed)
    }

    public func getSources() {
        sourceService.updateLocalStoreWithServerInfo(onSuccess: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.sources.value = [SectionModel(model: "", items: weakSelf.sourceService.getAll().map { SourceViewModel(source: $0) })]
        })
    }
}
