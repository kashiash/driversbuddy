//
//  CarDamage.swift
//  CanvasEditor
//
//  Created by Jacek Kosinski U on 12/03/2024.
//

import Foundation

enum CarDamage: String, CaseIterable {
    case scratch = "Scratch"
    case dent = "Dent"
    case brokenMirror = "Broken Mirror"
    case flatTire = "Flat Tire"
    // Add other damage types you're interested in

    var tooltip: String {
        switch self {
            case .scratch:
                return "Minor paint scratch"
            case .dent:
                return "Dent on the body"
            case .brokenMirror:
                return "Damaged side mirror"
            case .flatTire:
                return "Punctured or deflated tire"
        }
    }

    var symbol: String {
        switch self {
            case .scratch:
                return "hammer"
            case .dent:
                return "car"
            case .brokenMirror:
                return "magnifyingglass"
            case .flatTire:
                return "wrench.and.screwdriver"
        }


    }
    var symbolSelected: String {
        switch self {
            case .scratch:
                return "hammer.circle"
            case .dent:
                return "car.circle"
            case .brokenMirror:
                return "magnifyingglass.circle"
            case .flatTire:
                return "wrench.and.screwdriver"
        }
    }
}

