//
//  ViewModelBase.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 16/02/2018.
//  Copyright © 2018 Brian Sztamfater. All rights reserved.
//

import Foundation

protocol BaseViewModelProtocol {
    
    var navigationDelegate: NavigationDelegate? { get set }
}
