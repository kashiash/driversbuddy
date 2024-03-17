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
    case tab(Tab)
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



#Preview {
    SplitNavContentView()
}
