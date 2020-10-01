//
//  GustieMenuView.swift
//  GustieMenu
//
//  Created by Tucker Saude on 2/2/20.
//  Copyright © 2020 Tucker Saude. All rights reserved.
//

import Foundation
import SwiftUI

struct GustieMenuView: View {
    @EnvironmentObject var viewModel: MenuViewModel

    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all).zIndex(0)

            VStack(spacing: 0) {
                GustieMenuHeader()

                if self.viewModel.menu != Menu.empty {
                    MenuView(menu: viewModel.menu)
                } else if self.viewModel.isError {
                    Text("No data available...").padding()
                    Spacer()
                } else {
                    Spacer()
                }
            }.zIndex(1)

            if viewModel.showingCalendar {
                Group {
                    Color(.black).opacity(0.5).edgesIgnoringSafeArea(.all)
                    CalendarView()
                }.zIndex(2)
            }
        }
    }
}

struct GustieMenuHeader: View {
    @EnvironmentObject var viewModel: MenuViewModel

    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 16) {
           Text("Menu")
               .bold()
               .font(.largeTitle)
               .foregroundColor(Color("Primary"))

           Text(viewModel.title)
               .animation(.none)
               .onTapGesture {
                   withAnimation {
                       self.viewModel.showingCalendar.toggle()
                   }
               }
           Spacer()
           if viewModel.isLoading {
               ActivityIndicator(isAnimating: .constant(true), style: .medium)
           } else {
               Image(systemName: "calendar")
                   .font(.title)
                   .onTapGesture {
                       withAnimation {
                           self.viewModel.showingCalendar.toggle()
                       }
                   }
           }
        }
        .padding()
        .foregroundColor(.white)
        .background(Color("Black").edgesIgnoringSafeArea(.all))
    }
}

struct CalendarView: View {
    @EnvironmentObject var viewModel: MenuViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack {
                Spacer()
                VStack {
                    DatePicker("Menu Date", selection: self.$viewModel.date, displayedComponents: .date)
                        .labelsHidden()

                    HStack {
                        Button("Today") {
                            withAnimation {
                                self.viewModel.date = Date()
                            }
                        }.padding()
                        Spacer()
                        Button("Done") {
                            withAnimation {
                                self.viewModel.showingCalendar.toggle()
                                self.viewModel.fetch()
                            }
                        }.padding()
                    }
                }
                Spacer()
            }
            .background(Color(.white).edgesIgnoringSafeArea(.all))
        }
    }
}

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.color = .white
        return indicator
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
