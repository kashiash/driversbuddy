//
//  Tab.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 02/03/2024.
//

import Foundation
import SwiftUI

enum Tab: String, CaseIterable, Identifiable {
    case stations = "Stations"
    case cars = "Cars"
    case makes = "Makes"
    case documents = "Documents"
    case fastTasks = "Fast Tasks"
    case tasks = "Tasks"
    case expenses = "Expenses"
    case config = "Settings"

    var symbol: String {
        switch self {
        case .stations: "fuelpump"
        case .cars:
            "car"
        case .makes:
            "car.rear"
        case .documents:
            "doc"
        case .fastTasks:
            "calendar.badge.plus"
        case .tasks:
            "calendar"
        case .expenses:
            "eurosign"
        case .config:
            "gearshape"
        }
    }

    var id: String {
        self.rawValue
    }

    @ViewBuilder
    var tabContent: some View {
        switch self {
        case .stations: 
            VStack{
                Text("Some stations")
            }
        case .cars:
            VehicleListView()

        case .makes:
            CarMakeListView()

        case .documents:
            CarModelListView()
        case .fastTasks:
            TaskListView()
        case .tasks:
            TaskListView()
        case .expenses:
            VStack{
                Text("Some expenses")
            }
        case .config:
            VStack{
                Text("This is a config")
            }
        }
    }
}
