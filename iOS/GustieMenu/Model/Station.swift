//
//  Station.swift
//  GustieMenu
//
//  Created by Tucker Saude on 9/9/16.
//  Copyright © 2016 Tucker Saude. All rights reserved.
//

import Foundation

struct Station: Codable, Identifiable, Equatable {
    var id: String { name }

    let name: String
    let menuItems: [MenuItem]
}

extension Station: Comparable {
    static func < (lhs: Station, rhs: Station) -> Bool {
        lhs.menuItems.contains { $0.featured } && !rhs.menuItems.contains { $0.featured }
    }
}
