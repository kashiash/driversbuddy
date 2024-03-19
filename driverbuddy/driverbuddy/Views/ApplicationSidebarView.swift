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

            Section(header: Text("Tabs")) {
                ForEach(Tab.allCases) { tab in
                    NavigationLink(value: SettingsDetail.tab(tab)) {
                        HStack {
                            Image(systemName: tab.symbol)
                            Text(tab.rawValue)
                        }
                    }
                }
            }

            Section(header: Text("fast actions")) {
                ForEach(Mode.allCases) { mode in
                    NavigationLink(value: SettingsDetail.mode(mode)) {
                        Text(mode.localized)
                    }
                }
            }

            Section {
                Picker("Units", selection: $selectedUnit) {
                   ForEach(Units.allCases) { unit in
                       Text(unit.rawValue).tag(unit)
                   }
                }
                Toggle(isOn: $notification) {
                    Text("Notification")
                }
                Button {

                } label : {
                    HStack {
                        Text("Settings")
                        Image(systemName:  "gearshape")
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
