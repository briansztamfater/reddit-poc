//
//  SourceViewModel.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 18/4/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SourceViewModel {
    
    let identifier: Variable<String>
    let name: Variable<String>
    let url: Variable<URL>
    let detail: Variable<String>
    let language: Variable<Language>
    let country: Variable<Country>
    let category: Variable<SourceCategory>
    
    init(source: Source) {
        self.identifier = Variable<String>(source.id!)
        self.name = Variable<String>(source.name!)
        self.url = Variable<URL>(source.url!)
        self.detail = Variable<String>(source.detail!)
        self.language = Variable<Language>(source.language)
        self.country = Variable<Country>(source.country)
        self.category = Variable<SourceCategory>(source.category)
    }
    
}
