//
//  AppDelegate.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 3/17/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override init() {
        super.init()
        CompositionRoot.dependencies.build()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}
