//
//  Item.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 03/03/2024.
//

import Foundation
import SwiftData

@Model
class Item {
    var notifiedOn: Int
    var maintenanceID: Double
    var interval : Int
    var   notifiedAt : Int
    var   intervalMonths: Int
   // var uuid: UUID = UUID()
    var vehicle : Vehicle

    init(notifiedOn: Int, maintenanceID: Double, interval: Int, notifiedAt: Int, intervalMonths: Int,  vehicle: Vehicle) {
        self.notifiedOn = notifiedOn
        self.maintenanceID = maintenanceID
        self.interval = interval
        self.notifiedAt = notifiedAt
        self.intervalMonths = intervalMonths
        self.vehicle = vehicle
    }
}
