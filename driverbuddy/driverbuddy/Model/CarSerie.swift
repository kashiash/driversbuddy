//
//  CarSerie.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 03/03/2024.
//


import SwiftData

@Model
class CarSerie {
    var serieId: Int
    var model: CarModel
    var generation : CarGeneration
    var name : String

    init(serieId: Int, model: CarModel, generation: CarGeneration, name: String) {
        self.serieId = serieId
        self.model = model
        self.generation = generation
        self.name = name
    }
}
