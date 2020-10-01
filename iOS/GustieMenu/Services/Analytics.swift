//
//  Analytics.swift
//  GustieMenu
//
//  Created by Tucker Saude on 2/4/20.
//  Copyright © 2020 Tucker Saude. All rights reserved.
//

import Foundation
import FirebaseAnalytics

struct Analytics {
    private init() { }

    static let shared = Analytics()

    func logEvent(_ event: Event) {
        let (name, parameters) = event.toFirebaseEvent()
        FirebaseAnalytics.Analytics.logEvent(name, parameters: parameters)
    }
}

enum Event {
    case appOpen
    case menuSelected(id: String, success: Bool)
    case stationSelected(station: Station, expand: Bool)
}

extension Event {
    func toFirebaseEvent() -> (name: String, parameters: [String: Any]) {
        switch self {
        case .appOpen:
            return (name: AnalyticsEventAppOpen, parameters: [:])
        case let .menuSelected(id, success):
            return (name: AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterItemID: "menu-\(id)",
                AnalyticsParameterContentType: "menu",
                AnalyticsParameterSuccess: success ? 1 : 0
            ])
        case let .stationSelected(station, expand):
            return (name: AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterItemID: "station-\(station.name.lowercased().replacingOccurrences(of: " ", with: "-"))",
                AnalyticsParameterContentType: "\(expand ? "expand" : "contract")-station"
            ])
        }
    }
}

