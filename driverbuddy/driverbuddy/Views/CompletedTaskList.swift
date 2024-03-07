//
//  CompletedTaskList.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 06/03/2024.
//

import SwiftUI
import SwiftData

struct CompletedTaskList: View {
    @Binding var showAll: Bool
    @Query private var completedList: [Task]

    init(showAll: Binding<Bool>) {
        let predicate = #Predicate<Task> {$0.isCompleted}
        let sort = [SortDescriptor(\Task.lastUpdate,order:.reverse)]

        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)

        if !showAll.wrappedValue {
            //Limit to 15
            descriptor.fetchLimit = 15
        }
        _completedList = Query(descriptor,animation: .snappy)
        _showAll = showAll
    }

    var body: some View {
        Section {
            ForEach(completedList) {
                TaskRowView(task: $0)
            }
        } header: {
            HStack {
                Text("Completed")
                Spacer(minLength: 0)
                if showAll && !completedList.isEmpty {
                    Button("Show recents") {
                        showAll = false
                    }
                }
            }
        } footer: {
            if completedList.count == 15 && !showAll && !completedList.isEmpty {
                HStack {
                    Text("Showing recent 15 tasks")
                        .foregroundStyle(.gray)
                    Button("Show all") {
                        showAll = true
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TaskListView()
            .navigationTitle("ToDo List")
    }
}
