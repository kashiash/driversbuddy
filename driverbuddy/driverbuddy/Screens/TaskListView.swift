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
    var body: some View {
        List {
            Section(sctiveSectionTitle) {

            }

            CompletedTaskList()
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {}) {
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
