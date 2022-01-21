//
//  AppDelegate.swift
//  Cocktails
//
//  Created by Alek Sai on 18/01/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        // MARK: Application start
        
        let navigationController = UINavigationController()
        let drinksCoordinator = DrinksCoordinator(navigationController: navigationController)

        drinksCoordinator.start()

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}
