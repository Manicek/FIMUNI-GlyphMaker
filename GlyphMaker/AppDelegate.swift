//
//  AppDelegate.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 14/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        setupWindow()
        
        return true
    }
}

fileprivate extension AppDelegate {
    
    func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.black,
        ]
        
        let navigationController = GlyphViewController()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
