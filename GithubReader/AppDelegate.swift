//
//  AppDelegate.swift
//  GithubReader
//
//  Created by Andrii Horishnii on 2/7/18.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let appFlow = AppFlow(window: window!)
        appFlow.start()
        
        return true
    }

}
