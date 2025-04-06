//
//  AppDelegate.swift
//  SearchFlix
//
//  Created by Husnian Ali on 17.02.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let homeViewController = HomeBuilder.build()
        let navigationController = UINavigationController(rootViewController: homeViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}
