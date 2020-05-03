//
//  NavigationDelegate.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 01/02/2018.
//  Copyright © 2018 Brian Sztamfater. All rights reserved.
//

import Foundation

protocol NavigationDelegate: class {

    func navigate(_ identifier: String)
    func pop()
    func dismiss()
}
