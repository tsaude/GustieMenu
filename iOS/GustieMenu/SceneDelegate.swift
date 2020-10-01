//
//  SceneDelegate.swift
//  GustieMenu
//
//  Created by Tucker Saude on 2/1/20.
//  Copyright © 2020 Tucker Saude. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let viewModel = MenuViewModel(RemoteConfig())
            let view = GustieMenuView().environmentObject(viewModel)

            window.rootViewController = DarkHostingController(
                rootView: view
            )

            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        Analytics.shared.logEvent(.appOpen)
    }
}


class DarkHostingController<Content> : UIHostingController<Content> where Content : View {
    @objc override dynamic open var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}
