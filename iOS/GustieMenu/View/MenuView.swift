//
//  MenuView.swift
//  GustieMenu
//
//  Created by Tucker Saude on 2/2/20.
//  Copyright © 2020 Tucker Saude. All rights reserved.
//

import Foundation
import SwiftUI

struct MenuView: View {
    @EnvironmentObject var viewModel: MenuViewModel

    let menu: Menu

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(menu.stations) { station in
                    StationView(station: station)
                }

                Image("GAC").padding()
            }
        }
    }
}

struct StationView: View {
    let station: Station

    @State var isExpanded: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(station.name)
                    .bold()
                Spacer()
                if station.menuItems.contains { !$0.featured } {
                    Text(self.isExpanded ? "Show less" : "Show more")
                        .animation(.none)
                        .font(.footnote)
                }
            }
            .foregroundColor(Color("Black"))
            .padding()
            .background(Color("Primary").frame(maxWidth: .infinity))
            .onTapGesture {
                Analytics.shared.logEvent(.stationSelected(station: self.station, expand: !self.isExpanded))
                withAnimation {
                    self.isExpanded.toggle()
                }
            }

            ForEach(station.menuItems.filter { isExpanded || $0.featured }) { item in
                MenuItemView(menuItem: item)
            }
        }
    }
}

struct MenuItemView: View {
    let menuItem: MenuItem

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(menuItem.name)
                    .font(.body)
                    .fontWeight(.light)
                Text(menuItem.type)
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundColor(Color("Secondary"))
                    .padding(.leading, 8)
            }
            Spacer()
            Text(menuItem.price ?? "")
                .fontWeight(.light)
        }
        .padding()
        .background(Color("Background"))
    }
}


struct MenuView_Previews : PreviewProvider {
    static let menu = Menu(
        stations: [
            Station(name: "Hello Wok!", menuItems: [
                MenuItem(name: "Burger", price: "10.97", type: "Lunch", featured: true)
            ]),
            Station(name: "Burger Wok!", menuItems: [
                MenuItem(name: "Super", price: "10.97", type: "Lunch", featured: false)
            ]),
        ]
    )
    static var previews: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            MenuView(menu: menu)
        }.previewDevice("iPhone 11")
    }
}
