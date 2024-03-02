//
//  Tab.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 02/03/2024.
//

import Foundation

enum Tab: String, CaseIterable {
    case stations = "Stations"
    case cars = "Cars"
    case documents = "Documents"
    case config = "Settings"

    var symbol: String {
        switch self {
        case .stations: "fuelpump.fill"
        case .cars:
            "car.fill"
        case .documents:
            "doc.fill"
        case .config:
            "gearshape.fill"
        }
    }
}
