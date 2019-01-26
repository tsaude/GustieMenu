//
//  StationViewModel.swift
//  GustieMenu
//
//  Created by Tucker Saude on 1/25/19.
//  Copyright © 2019 Tucker Saude. All rights reserved.
//

import Foundation

struct StationViewModel {
    let name: String
    let isShowingMenuItems: Bool

    func toggleShowingMenuItems() -> StationViewModel {
        return StationViewModel(name: name, isShowingMenuItems: !isShowingMenuItems)
    }

    private init(name: String, isShowingMenuItems: Bool) {
        self.name = name
        self.isShowingMenuItems = isShowingMenuItems
    }

    init(from station: Station) {
        name = station.name
        isShowingMenuItems = false
    }
}
