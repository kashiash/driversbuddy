//
//  CarMake.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 03/03/2024.
//

import Foundation
import SwiftData

@Model
class CarMake {
    var makeId: Int
    var Name: String

    init(makeId: Int, name: String) {
        self.makeId = makeId
        self.Name = name
    }
}
