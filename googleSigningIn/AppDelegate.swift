//
//  AppDelegate.swift
//  googleSigningIn
//
//  Created by Andrey Rybalkin on 20.03.2023.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        FirebaseApp.configure()

        let loginVC = AuthViewController()
        
        window?.rootViewController = loginVC
        window?.makeKeyAndVisible()
        
        return true
    }


}

