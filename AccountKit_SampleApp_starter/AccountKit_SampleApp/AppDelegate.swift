//
//  AppDelegate.swift
//  AccountKit_SampleApp
//
//  Created by Gabrielle Miller-Messner on 11/27/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
// TODO: import CoreKit


// MARK: - AppDelegate: UIResponder, UIApplicationDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties
    
    var window: UIWindow?
    
    // MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        return true
    }

    // TODO: Activate App Events


}
