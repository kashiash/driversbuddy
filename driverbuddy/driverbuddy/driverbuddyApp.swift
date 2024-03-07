//
//  driverbuddyApp.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 02/03/2024.
//

import SwiftUI

@main
struct driverbuddyApp: App {
    var body: some Scene {
        WindowGroup {
          //  ContentView()
            NavigationStack{
                TaskListView()
            }
        }
        .modelContainer(for: [CarMake.self,CarModel.self,Vehicle.self,Task.self])
    }
}
