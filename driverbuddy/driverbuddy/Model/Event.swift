//
//  Event.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 03/03/2024.
//

import Foundation
import SwiftData
@Model
class Event {
    var notes: String
    var type: Int
    var date: Double
    var diy: Bool
    var paymentMethod: PaymentMethod = PaymentMethod.card
    var cost: Double

    init(notes: String, type: Int, date: Double, diy: Bool, paymentMethod: PaymentMethod, cost: Double) {
        self.notes = notes
        self.type = type
        self.date = date
        self.diy = diy
        self.paymentMethod = paymentMethod
        self.cost = cost
    }
}

enum PaymentMethod: String ,Codable,CaseIterable {
    case cash = "Cash"
    case card = "Card"
    case wire = "Wire"
    case blik = "Blik"
    case fuelCard = "Fuel Card"
}
