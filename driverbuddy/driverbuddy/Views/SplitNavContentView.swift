//
//  SplitNavContentView.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 16/03/2024.
//

import SwiftUI


enum SettingsDetail: Hashable, Equatable {
    case events
    case mode(Mode)
}


enum Mode: String, CaseIterable, Identifiable {
    var id: String {
        self.rawValue
    }

    case walk
    case publicTransit
    case bicycle
    case automobile

    var localized: String {
        self.rawValue
    }
}

struct SplitNavContentView: View {

    @State private var visibility: NavigationSplitViewVisibility = .all

    @State private var selectedDetail: SettingsDetail?

    var body: some View {
        NavigationSplitView(columnVisibility: $visibility) {
            ApplicationSidebarView(selectedDetail: $selectedDetail)
        } detail: {
            ApplicationDetailView(selectedDetail: $selectedDetail)
        }
        // the next modifier also modifies the list style of SettingsSidebarView
        // when 2 columns are displayed
        .navigationSplitViewStyle(.balanced)
    }
}

struct ApplicationDetailView: View {

    @Binding var selectedDetail: SettingsDetail?
    @State private var presentedPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $presentedPath) {
            Group {
                if let selectedDetail {
                    switch selectedDetail {
                    case .events:
                      //  EventPreferencesSettingsView()

                        VehicleListView()
                    case .mode(let mode):
                        Form{
                            Text(mode.rawValue)
                                .navigationTitle(mode.rawValue)
                        }
                    }
                }
                // if selectedDetail is nil, the user hasn't selected anything
                // in the sidebar, so nothing should be shown.
                // You might add something like "Please select---"
            }
            .onChange(of: selectedDetail) { newSelectedDetail in
                presentedPath = NavigationPath()
            }
        }
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    SplitNavContentView()
}
