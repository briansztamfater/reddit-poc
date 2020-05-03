//
//  ViewControllerBase.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 01/02/2018.
//  Copyright © 2018 Brian Sztamfater. All rights reserved.
//

import UIKit

extension UIViewController: NavigationDelegate {
    
    func navigate(_ identifier: String) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: identifier, sender: self)
        }
    }
    
    func pop() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func dismiss() {
        if presentingViewController != nil {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
