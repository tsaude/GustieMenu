//
//  AppDelegate.swift
//  GustieMenu
//
//  Created by Tucker Saude on 9/8/16.
//  Copyright © 2016 Tucker Saude. All rights reserved.
//

import UIKit

import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let firebaseConfig = Bundle.main.path(forResource: Environment.firebaseConfigFilename, ofType: "plist")
        guard let opts = FirebaseOptions(contentsOfFile: firebaseConfig!) else { fatalError("Couldn't load Firebase config file") }
        FirebaseApp.configure(options: opts)

        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}

