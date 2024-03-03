//
//  Vehicle.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 03/03/2024.
//

import Foundation
import SwiftData

@Model
class Vehicle {
    var pressureUnits: PresureUnit = PresureUnit.psi
    var plate: String
    var consumptionUnits: ConsumptionUnit = ConsumptionUnit.kmPerLiter
    var year: Int

    var trim: String
    var creationDate: TimeInterval
    var name: String
    var units: Units = Units.km
    var insurance: String
    var type: VehicleType = VehicleType.car
    var tpFront: Int
   var tpRear: Int
    var status: Status = Status.active
    var fuelUnits: FuelUnit = FuelUnit.liters
  //  var make: String
  //  var uuid: UUID = UUID()
  //  var model: String
    var vin: String
    var fuelType: FuelType = FuelType.gasoline
    var notes: String
    var registration: String
    
    init(plate: String, year: Int, trim: String, creationDate: TimeInterval, name: String, units: Units, insurance: String, type: VehicleType, tpFront: Int, tpRear: Int, status: Status, fuelUnits: FuelUnit,vin: String, fuelType: FuelType, notes: String, registration: String) {
        self.plate = plate
        self.year = year
        self.trim = trim
        self.creationDate = creationDate
        self.name = name
        self.units = units
        self.insurance = insurance
        self.type = type
        self.tpFront = tpFront
        self.tpRear = tpRear
        self.status = status
        self.fuelUnits = fuelUnits
    //    self.uuid = uuid
        self.vin = vin
        self.fuelType = fuelType
        self.notes = notes
        self.registration = registration
    }

}

enum Status: String ,Codable,CaseIterable {
    case active = "Active"
    case archived = "Archive"
    case sold = "Sold"
    case strage = "In Storage"
}

enum Units: String, Codable, CaseIterable {
    case km = "Kilometers"
    case miles = "Miles"
    case imperial = "Miles (Imperial)"
}

enum VehicleType: String, Codable, CaseIterable {
    case car = "Car"
    case truck = "Truck"
    case trailer = "Trailer"
    case bus = "Miles"
    case bike = "Motorcycle"
}

enum FuelType: String, Codable, CaseIterable {
    case diesel = "Kilometers"
    case electric = "Electric"
    case gas = "Gas"
    case gasoline = "Gasoline"
    case hybrid = "Hybrid"
    case other = "Other"
}
enum FuelUnit: String, Codable, CaseIterable {
    case galons = "Gallons"
    case liters = "Liters"
}

enum PresureUnit: String, Codable, CaseIterable {
    case bar = "Bar"
    case kpa = "Kilopascal"
    case psi = "Pound per square inch"
}

enum ConsumptionUnit: String, Codable, CaseIterable {
    case kmPerLiter = "Kilometers / Liter"
    case litersPer100km = "Liters /100 km"
    case mpg = "MPG"
    case imp = "MPG (Imperial)"
}
