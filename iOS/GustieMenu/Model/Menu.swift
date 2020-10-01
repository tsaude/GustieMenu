//
//  Menu.swift
//  GustieMenu
//
//  Created by Tucker Saude on 2/1/20.
//  Copyright © 2020 Tucker Saude. All rights reserved.
//

import Foundation

struct Menu: Codable, Equatable {
    let stations: [Station]

    static let empty = Menu(stations: [])
}
