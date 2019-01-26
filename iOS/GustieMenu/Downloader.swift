//
//  Downloader.swift
//  GustieMenu
//
//  Created by Tucker Saude on 9/9/16.
//  Copyright © 2016 Tucker Saude. All rights reserved.
//

import Foundation
import Alamofire

class Downloader {
    static let sharedInstance = Downloader()

    private init() { }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter
    }()
    
    func downloadStations(date: Date?, completion: @escaping ([Station], String) -> Void) {
        let dateString: String
        if let date = date {
            dateString = dateFormatter.string(from: date)
        } else {
            dateString = ""
        }

        Alamofire.request("\(Environment.rootURL)/menu/\(dateString)", method: .get).responseData { response in
            guard let data = response.data else {
                print("Response failed: \(response.error.debugDescription)")
                completion([], "Failure")
                return
            }

            let decoder = JSONDecoder()

            do {
                let menu = try decoder.decode(MenuResponse.self, from: data)
                completion(menu.stations, menu.date)
            } catch {
                print("Decoding failed: \(error)")
                completion([], "Failure")
            }
        }
    }
}

struct MenuResponse: Codable {
    let stations: [Station]
    let date: String
}
