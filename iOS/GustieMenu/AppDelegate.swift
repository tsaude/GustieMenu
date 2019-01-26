//
//  AppDelegate.swift
//  GustieMenu
//
//  Created by Tucker Saude on 9/8/16.
//  Copyright © 2016 Tucker Saude. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        if case .release = Environment.scheme {
            let builder = FlurrySessionBuilder()
                .withAppVersion("1.0")
                .withLogLevel(FlurryLogLevelAll)
                .withCrashReporting(true)
                .withSessionContinueSeconds(10)

            Flurry.startSession(Environment.flurryApiKey, with: builder)
        }

        return true
    }
}

