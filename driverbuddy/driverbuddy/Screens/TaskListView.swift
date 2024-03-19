//
//  TaskListView.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 06/03/2024.
//

import SwiftUI
import SwiftData

struct TaskListView: View {
    @Query(filter: #Predicate<Task> {!$0.isCompleted},
           sort: [SortDescriptor(\Task.lastUpdate, order: .reverse)]
           ,animation:.snappy) private var activeTasks: [Task]

    @Environment(\.modelContext)  private var context
    @State private var showAll = false

    var body: some View {
        List {
            Section(sctiveSectionTitle) {
                ForEach(activeTasks) {
                    TaskRowView(task: $0)
                }
            }

            CompletedTaskList(showAll: $showAll)
        }
        .navigationBarTitle("Tasks")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    let task = Task(taskDescription: "", priority: .normal)
                    context.insert(task)

                }) {
                    Image(systemName: "plus.circle.fill")
                        .fontWeight(.light)
                        .font(.largeTitle)
                }
            }
        }
    }

    var sctiveSectionTitle: String {
        let count = activeTasks.count
        return count == 0 ? "Active" : "Active \(count)"
    }
}

#Preview {
    NavigationStack {
        TaskListView()
            .navigationTitle("ToDo List")
    }

}
