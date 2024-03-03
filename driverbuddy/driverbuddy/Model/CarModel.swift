//
//  CarModel.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 03/03/2024.
//

import Foundation
import SwiftData

@Model
class CarModel {
    var modelId: Int
    var name: String
    var make: CarMake


    init(modelId: Int, name: String, make: CarMake) {
        self.modelId = modelId
        self.name = name
        self.make = make
    }
}
