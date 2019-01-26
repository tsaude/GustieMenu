//
//  MenuItemViewModel.swift
//  GustieMenu
//
//  Created by Tucker Saude on 1/25/19.
//  Copyright © 2019 Tucker Saude. All rights reserved.
//

import Foundation

struct MenuItemViewModel {
    let name: String
    let price: String
    let type: String
    let url: String

    init(from item: MenuItem) {
        name = item.name
        price = item.price
        type = item.type
        url = item.url
    }
}
