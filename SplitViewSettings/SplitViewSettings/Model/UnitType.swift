//
//  UntType.swift
//  SplitViewSettings
//
//  Created by Jacek Kosinski U on 10/03/2024.
//

import Foundation
enum UnitType: String, CaseIterable, Identifiable {
    case automatic = "Automatic"
    case metric = "Metric"
    case imperial = "Imperial"

    var id: String { self.rawValue }
}
