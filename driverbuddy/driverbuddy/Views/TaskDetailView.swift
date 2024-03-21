//
//  TaskDetailView.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 21/03/2024.
//

import SwiftUI
import SwiftData

struct TaskDetailView: View {
    @State var task: Task
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

   @State private var taskDescription: String = ""
    @State private var reminderEnabled = false
    @State private var issueReminderTime: Date = .now
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    Text("Basic Information")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    TextField("Description", text: $task.taskDescription,axis:.vertical)
                }
            }
            Section("Reminders") {
                Toggle("Show reminders",isOn: $reminderEnabled.animation())
                if reminderEnabled {
                    DatePicker("Reminder time", selection: $issueReminderTime, displayedComponents: .hourAndMinute)
                }
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Task.self, configurations: config)

        let task = Task(taskDescription: "Zajebiste zadanie", priority: .High)

        return TaskDetailView(task: task)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
