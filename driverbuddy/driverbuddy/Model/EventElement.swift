//
//  EventElement.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 03/03/2024.
//

import Foundation
import SwiftData



@Model
class EventElement {
    var items: [Item]
    var event: Event
    var odometer: Odometer
    var fuelUp: FuelUp?
    var shopID: String?
   // var fuelBrand: FuelBrand?

    enum CodingKeys: String, CodingKey {
        case items, event, odometer, fuelUp
        case shopID = "shopId"
        case fuelBrand
    }

    init(items: [Item], event: Event, odometer: Odometer, fuelUp: FuelUp? = nil, shopID: String? = nil) {
        self.items = items
        self.event = event
        self.odometer = odometer
        self.fuelUp = fuelUp
        self.shopID = shopID
    }
}
