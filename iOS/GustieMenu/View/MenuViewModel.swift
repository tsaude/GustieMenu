//
//  MenuViewModel.swift
//  GustieMenu
//
//  Created by Tucker Saude on 2/2/20.
//  Copyright © 2020 Tucker Saude. All rights reserved.
//

import Foundation
import Combine

class MenuViewModel: ObservableObject {
    @Published var menu: Menu = .empty
    @Published var showingCalendar: Bool = false
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    @Published var date: Date = Date()

    var title: String {
        displayDateFormatter.string(from: date)
    }

    private var currentTask: URLSessionDataTask?
    private var config: RemoteConfig
    private var bag = Set<AnyCancellable>()

    init(_ config: RemoteConfig) {
        self.isLoading = true
        self.config = config
        config.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in
                self.fetch()
                #if DEBUG
                print("Config updated! \(config.config)")
                #endif
            }.store(in: &bag)
    }

    func fetch() {
        let dateString = requestDateFormatter.string(from: date)

        currentTask?.cancel()
        self.isLoading = true

        currentTask = URLSession.shared.dataTask(with: config.rootUrl.appendingPathComponent("/menu/\(dateString)")) { [unowned self] data, response, error in
            self.currentTask = nil
            DispatchQueue.main.async {
                let decoder = JSONDecoder()

                if let data = data,
                    let menu = try? decoder.decode(Menu.self, from: data) {
                    self.menu = menu
                    self.isError = false
                } else {
                    self.menu = .empty
                    self.isError = true
                }

                Analytics.shared.logEvent(.menuSelected(id: dateString, success: !self.isError))

                self.isLoading = false
            }
        }

        currentTask?.resume()
    }
}

fileprivate let requestDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "MM-dd-yyyy"
    return formatter
}()

fileprivate let displayDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .full
    return formatter
}()
