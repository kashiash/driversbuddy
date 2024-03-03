//
//  FuelUp.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 03/03/2024.
//

import Foundation
import SwiftData

@Model
class FuelUp {
    var partial: Bool
    var rebate: Int
    var cityPercentage: Int
    var quantity: Double
 //   var uuid: UUID = UUID()
    var reset: Bool
    var pricePerVol: Double
    var octane: String?
    var vehicle: Vehicle

    init(partial: Bool, rebate: Int, cityPercentage: Int, quantity: Double,  reset: Bool, pricePerVol: Double, octane: String? = nil, vehicle: Vehicle) {
        self.partial = partial
        self.rebate = rebate
        self.cityPercentage = cityPercentage
        self.quantity = quantity

        self.reset = reset
        self.pricePerVol = pricePerVol
        self.octane = octane
        self.vehicle = vehicle
    }
}
