//
//  Tab.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 02/03/2024.
//

import Foundation
import SwiftUI

enum Tab: String, CaseIterable {
    case stations = "Stations"
    case cars = "Cars"
    case documents = "Documents"
    case tasks = "Tasks"
    case expenses = "Expenses"
    case config = "Settings"

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
        }
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
                Text("Some cars")
            }
        case .documents:
            VStack{
                Text("Some documents")
            }
        case .tasks:
            VStack{
                Text("Some tasks")
            }
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
