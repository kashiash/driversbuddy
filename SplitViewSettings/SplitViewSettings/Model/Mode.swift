//
//  Mode.swift
//  SplitViewSettings
//
//  Created by Jacek Kosinski U on 10/03/2024.
//

import Foundation
enum Mode: String, CaseIterable, Identifiable {
    var id: String {
        self.rawValue
    }

    case walk
    case publicTransit
    case bicycle
    case automobile

    var localized: String {
        self.rawValue
    }
}
