//
//  Environment.swift
//  GustieMenu
//
//  Created by Tucker Saude on 1/26/19.
//  Copyright © 2019 Tucker Saude. All rights reserved.
//

import Foundation

enum Environment {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    static let rootURL: URL = {
        guard let rootURLstring = Environment.infoDictionary["ROOT_URL"] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        guard let url = URL(string: rootURLstring) else {
            fatalError("Root URL is invalid")
        }
        return url
    }()

    static let flurryApiKey: String = {
        guard let apiKey = Environment.infoDictionary["FLURRY_API_KEY"] as? String else {
            fatalError("API Key not set in plist for this environment")
        }
        return apiKey
    }()

    static let appVersion: String = {
        guard let apiKey = Environment.infoDictionary["CFBundleVersion"] as? String else {
            fatalError("App Version not set in plist for this environment")
        }
        return apiKey
    }()

    static let scheme: Scheme = {
        guard let schemeString = Environment.infoDictionary["SCHEME"] as? String,
            let scheme = Scheme.init(rawValue: schemeString) else {
                fatalError("Scheme not set in plist for this environment")
        }
        return scheme
    }()
}

enum Scheme: String {
    case release = "RELEASE"
    case debug = "DEBUG"
}
