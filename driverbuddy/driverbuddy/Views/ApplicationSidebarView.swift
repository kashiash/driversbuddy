//
//  ApplicationSidebarView.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 16/03/2024.
//

import SwiftUI

struct ApplicationSidebarView: View {

    @Binding var selectedDetail: SettingsDetail?

    @State private var selectedUnit: Units = .km
    @State private var notification: Bool = true

    var body: some View {
        List(selection: $selectedDetail) {
            Section {
                Picker("Units", selection: $selectedUnit) {
                   ForEach(Units.allCases) { unit in
                       Text(unit.rawValue).tag(unit)
                   }
                }
                Toggle(isOn: $notification) {
                    Text("Notification")
                }
                NavigationLink(value: SettingsDetail.events) {
                    Text("Events")
                }
                NavigationLink(value: SettingsDetail.events) {
                    Text("Makes")
                }
                NavigationLink(value: SettingsDetail.events) {
                    Text("Models")
                }
            }

            Section(header: Text("Modes")) {
                ForEach(Mode.allCases) { mode in
                    NavigationLink(value: SettingsDetail.mode(mode)) {
                        Text(mode.localized)
                    }
                }
            }

        }
        .listStyle(.grouped)
    }
}

#Preview {
    @State var selectedCategory: SettingsDetail?

    return
    ( NavigationStack {
        ApplicationSidebarView(selectedDetail: $selectedCategory)
    })
}
