//
//  SourceService.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 4/13/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import Foundation

final class SourceService: BaseService<Source> {
    
    public var currentSourceId: String?
    
    public override func updateLocalStoreWithServerInfo(onSuccess: (() -> Void)? = nil, onError: ((Error) -> Void)? = nil) {
        restClient.getSources(language: Language.English) { [weak self] result in
            guard let weakSelf = self else {
                return
            }
            do {
                let sources = try result.unwrap()
                weakSelf.persistence.saveAll(objects: sources)
                onSuccess?()
            } catch {
                onError?(error)
            }
        }
    }
}
