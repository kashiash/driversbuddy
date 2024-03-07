//
//  TaskList.swift
//  TaskList
//
//  Created by Jacek Kosinski U on 07/03/2024.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: .now)

        entries.append(entry)


        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date

}

struct TaskListEntryView : View {
    var entry: Provider.Entry
    @Query(taskDescriptor,animation: .snappy) private var activeList: [Task]
    var body: some View {
        VStack {
            ForEach(activeList) { task in
                HStack(spacing:20) {
                    //Intent action button
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "circle")
                    })
                    .font(.callout)
                    .tint(task.priority.color.gradient)
                    .buttonBorderShape(.circle)

                    Text(task.taskDescription)
                        .font(.callout)
                        .lineLimit(1)
                    Spacer(minLength: 0)


                }
            }

        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
    }

    static var taskDescriptor: FetchDescriptor<Task> {
        let predicate = #Predicate<Task> { !$0.isCompleted }
        let sort = [SortDescriptor(\Task.lastUpdate,order:.reverse)]

        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        descriptor.fetchLimit = 3
        return descriptor
    }
}

struct TaskList: Widget {
    let kind: String = "TaskList"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            TaskListEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    TaskList()
} timeline: {
    SimpleEntry(date: .now)

}
