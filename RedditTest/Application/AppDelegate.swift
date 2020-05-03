//
//  AppDelegate.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 3/17/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import UIKit
import Dip

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let container = DependencyContainer.configure()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}

