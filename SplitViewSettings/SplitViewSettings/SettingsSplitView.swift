//
//  SwiftUIView.swift
//  SplitViewSettings
//
//  Created by Jacek Kosinski U on 10/03/2024.
//

import SwiftUI

struct SettingsSplitView: View {

    /// show all columns, side by side
    @State private var visibility: NavigationSplitViewVisibility = .all

    @State private var selectedDetail: SettingsDetail?

    var body: some View {
        NavigationSplitView(columnVisibility: $visibility) {
            SettingsSidebarView(selectedDetail: $selectedDetail)
        } detail: {
            SettingsDetailView(selectedDetail: $selectedDetail)
        }
        // the next modifier also modifies the list style of SettingsSidebarView
        // when 2 columns are displayed
        .navigationSplitViewStyle(.balanced)
    }
}

struct SettingsDetailView: View {

    @Binding var selectedDetail: SettingsDetail?
    @State private var presentedPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $presentedPath) {
            Group {
                if let selectedDetail {
                    switch selectedDetail {
                    case .events:
                        EventPreferencesSettingsView()
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
    SettingsSplitView()
}
