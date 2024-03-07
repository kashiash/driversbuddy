//
//  Task.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 03/03/2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Task {
  //  private(set) var taskId: String = UUID().uuidString
    var taskId: UUID = UUID()
    var taskDescription: String
    var dueDate: Date = Date.now.addingTimeInterval(5 * 600)
    var notes: String
    var isCompleted:Bool = false
    var priority: Priority = Priority.normal
    var lastUpdate: Date = Date.now


    init(taskDescription: String,  priority: Priority) {
        self.taskDescription = taskDescription
        self.dueDate = .now.addingTimeInterval(5 * 600)
        self.notes = ""
        self.isCompleted = false
        self.priority = priority
    }

}

enum Priority: String, Codable, CaseIterable {
    case normal = "Normal"
    case medium = "Medium"
    case High = "High"


    var color: Color {
        switch self {
        case .normal:
            return .green
        case .medium:
            return .yellow
        case .High:
            return .red
        }
    }
}
