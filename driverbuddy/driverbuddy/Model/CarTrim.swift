//
//  CarTrim.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 03/03/2024.
//

import Foundation
import SwiftData

@Model
class CarTrim {
    var trimId: Int
    var serie: CarSerie
    var model: CarModel
    var name: String
    var fromYear: Int
    var toYear: Int

    init(trimId: Int, serie: CarSerie, model: CarModel, name: String, fromYear: Int, toYear: Int) {
        self.trimId = trimId
        self.serie = serie
        self.model = model
        self.name = name
        self.fromYear = fromYear
        self.toYear = toYear
    }
}
