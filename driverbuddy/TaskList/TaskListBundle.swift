//
//  TaskListBundle.swift
//  TaskList
//
//  Created by Jacek Kosinski U on 07/03/2024.
//

import WidgetKit
import SwiftUI

@main
struct TaskListBundle: WidgetBundle {
    var body: some Widget {
        TaskList()
        TaskListLiveActivity()
    }
}
