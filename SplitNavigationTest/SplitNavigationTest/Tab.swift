//
//  Tab.swift
//  SplitNavigationTest
//
//  Created by Jacek Kosinski U on 08/03/2024.
//

import Foundation
import SwiftUI

enum Tab: String,Identifiable, CaseIterable {
    case map = "🗺️ Map"
    case stations = "⛽️ Stations"
    case cars = "🚘 Cars"
    case documents = "📑 Documents"
    case tasks = "📋 Tasks"
    case expenses = "🫰Expenses"
    case config = "⚙️ Settings"

    var symbol: String {
        switch self {
        case .stations: "fuelpump"
        case .cars:
            "car"
        case .documents:
            "doc"
        case .tasks:
            "calendar"
        case .expenses:
            "eurosign"
        case .config:
            "gearshape"
        case .map:
            "map"
        }
    }
    var id: Self {

            return self
        }

    @ViewBuilder
    var tabContent: some View {
        Text("Tab Content")
        Image(systemName: symbol)
        switch self {
        case .stations:
            VStack{
                Text("Some stations")
            }
        case .cars:

            VStack{
                Text("Some  VehicleListView()")
            }
        case .documents:

            VStack{
                Text("Some CarMakeListView()")
            }
        case .tasks:

            VStack{
                Text("Some TaskListView()")
            }
        case .expenses:
            VStack{
                Text("Some TaskListView()")
            }
        case .config:
            VStack{
                Text("This is a config")
            }
        case .map:
            VStack{
                Text("some map")
            }
        }
    }
}

