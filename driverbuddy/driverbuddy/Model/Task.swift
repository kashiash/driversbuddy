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
    var dueDate: Date
    var notes: String
    var isCompleted:Bool = false
    var priority: Priority = Priority.normal

    init(taskDescription: String, dueDate: Date, notes: String, isCompleted: Bool, priority: Priority) {
        self.taskDescription = taskDescription
        self.dueDate = dueDate
        self.notes = notes
        self.isCompleted = isCompleted
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
