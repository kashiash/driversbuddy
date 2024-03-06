//
//  CompletedTaskList.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 06/03/2024.
//

import SwiftUI
import SwiftData

struct CompletedTaskList: View {
    @Query private var completedList: [Task]
    init() {
        let predicate = #Predicate<Task> {$0.isCompleted}
        let sort = [SortDescriptor(\Task.lastUpdate,order:.reverse)]

        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)

        if !showAll {
            //Limit to 15
            descriptor.fetchLimit = 15
        }
    }

    @State private var showAll = false
    var body: some View {
        Section {

        } header: {
            HStack {
                Text("Completed")
                Spacer(minLength: 0)
                if showAll {
                    Button("Show recent 15 tasks") {
                        showAll = false
                    }
                }
            }
        } footer: {
            if  !showAll {
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
