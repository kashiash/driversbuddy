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
    case mechanical = "Mechanical issue"
    case flatTire = "Flat Tire"
    // Add other damage types you're interested in

    var tooltip: String {
        switch self {
            case .scratch:
                return "Porysowane"
            case .dent:
                return "Wgniecenie"
            case .brokenMirror:
                return "Uszodznie na szybie"
        case .mechanical:
            return "Uszkodzenie mechaniczne"
            case .flatTire:
                return "Uszkodzenie opony"
        }
    }

    var symbol: String {
        switch self {
            case .scratch:
                return "scribble"
            case .dent:
                return "hammer"
            case .brokenMirror:
                return "magnifyingglass"
        case .mechanical:
            return "wrench.and.screwdriver"
            case .flatTire:
                return "exclamationmark.tirepressure"
        }
    }

}

