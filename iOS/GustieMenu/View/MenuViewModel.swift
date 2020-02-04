//
//  MenuViewModel.swift
//  GustieMenu
//
//  Created by Tucker Saude on 2/2/20.
//  Copyright © 2020 Tucker Saude. All rights reserved.
//

import Foundation
import Combine

fileprivate let requestDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    formatter.dateFormat = "MM-dd-yyyy"
    return formatter
}()

fileprivate let displayDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    formatter.dateFormat = "EEEE, MMM d, yyyy"
    return formatter
}()

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

    init() {
        fetch()
    }

    func fetch() {
        let dateString = requestDateFormatter.string(from: date)

        currentTask?.cancel()
        self.isLoading = true
        currentTask = URLSession.shared.dataTask(with: Environment.rootURL.appendingPathComponent("/menu/\(dateString)")) { [weak self] data, response, error in
            self?.currentTask = nil

            DispatchQueue.main.async {
                guard let data = data else {
                    self?.menu = .empty
                    self?.isError = true
                    return
                }

                let decoder = JSONDecoder()

                do {
                    let menu = try decoder.decode(Menu.self, from: data)
                    self?.menu = menu
                    self?.isError = false
                } catch {
                    self?.menu = .empty
                    self?.isError = true
                }

                self?.isLoading = false
            }
        }

        currentTask?.resume()
    }
}
