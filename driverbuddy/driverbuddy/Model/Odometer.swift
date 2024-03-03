//
//  Odometer.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 03/03/2024.
//

import Foundation
import SwiftData

@Model
class Odometer {
  //  var uuid: UUID = UUID()
    var reading: Int
    var date: Double
    var units: Units = Units.km
    var vehicle: Vehicle

    init( reading: Int, date: Double, units: Units, vehicle: Vehicle) {

        self.reading = reading
        self.date = date
        self.units = units
        self.vehicle = vehicle
    }
}
