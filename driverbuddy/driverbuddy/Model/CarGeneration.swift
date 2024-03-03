//
//  CarGeneration.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 03/03/2024.
//

import Foundation
import SwiftData


@Model
class CarGeneration {
    var generationId: Int
    var model: CarModel
    var name: String
    var FromYear: Int
    var ToYear: Int
    init(generationId: Int, model: CarModel, name: String, FromYear: Int, ToYear: Int) {
        self.generationId = generationId
        self.model = model
        self.name = name
        self.FromYear = FromYear
        self.ToYear = ToYear
    }
}
