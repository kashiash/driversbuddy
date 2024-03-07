//
//  TaskRowView.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 07/03/2024.
//

import SwiftUI

struct TaskRowView: View {
    @Bindable var task: Task
    @FocusState private var isActive: Bool
    @Environment(\.modelContext) private var context
    var body: some View {
        HStack (spacing: 8){
            if !isActive && !task.taskDescription.isEmpty {
                Button(action: {
                    task.isCompleted.toggle()
                    task.lastUpdate = .now
                }, label: {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .padding(3)
                        .contentShape(.rect)
                        .foregroundStyle(task.isCompleted ? .gray :.primary)
                        .contentTransition(.symbolEffect(.replace))
                })
            }
            TextField("Record Video", text: $task.taskDescription)
                .strikethrough(task.isCompleted)
                .foregroundColor(task.isCompleted ? .gray : .primary)
                .focused($isActive)
            // hide menu buttons when keyboard is active
            if !isActive && !task.taskDescription.isEmpty {
                Menu{
                    ForEach(Priority.allCases, id: \.rawValue) { priority in
                        Button(action: {
                            task.priority = priority
                        }, label: {
                            HStack {
                                Text(priority.rawValue)
                                if task.priority == priority {
                                    Image(systemName: "checkmark")
                                }
                            }
                        })
                    }
                } label: {
                    Image(systemName: "circle.fill")
                        .font(.title2)
                        .padding(3)
                        .contentShape(.rect)
                        .foregroundStyle(task.priority.color.gradient)
                }
            }
        }
        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
        .animation(.snappy, value: isActive)
        .onAppear {
            isActive = task.taskDescription.isEmpty
        }
        //Swipe to delete
        .swipeActions(edge:.trailing , allowsFullSwipe: false) {
            Button("",systemImage: "trash") {
                context.delete(task)
            }
        }
        .onSubmit(of: /*@START_MENU_TOKEN@*/.text/*@END_MENU_TOKEN@*/) {
            if task.taskDescription.isEmpty {
                //Delete task because is empty
                context.delete(task)
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
