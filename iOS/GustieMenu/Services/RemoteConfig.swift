//
//  RemoteConfig.swift
//  GustieMenu
//
//  Created by Tucker Saude on 2/4/20.
//  Copyright © 2020 Tucker Saude. All rights reserved.
//

import Foundation
import Firebase
import Combine

class RemoteConfig: ObservableObject {
    @Published var config: Config = .defaults

    init() {
        #if DEBUG
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
        #else
        Firebase.RemoteConfig.remoteConfig().setDefaults(Config.defaults.toDict())
        Firebase.RemoteConfig.remoteConfig().fetch(withExpirationDuration: 0) { [unowned self] (status, error) in
            Firebase.RemoteConfig.remoteConfig().activate { (error) in
                self.config = Firebase.RemoteConfig.remoteConfig().toConfig()
            }
        }
        #endif
    }

    var rootUrl: URL { config.rootUrl }
}

struct Config {
    let rootUrl: URL

    static let defaults: Config = Config(rootUrl: Environment.rootURL)

    func toDict() -> [String: NSObject] {
        ["rootUrl": rootUrl.absoluteString as NSObject]
    }
}

extension Firebase.RemoteConfig {
    func toConfig() -> Config {
        Config(rootUrl: URL(string: self["rootUrl"].stringValue!)!)
    }
}
