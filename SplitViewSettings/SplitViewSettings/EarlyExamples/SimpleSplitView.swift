//
//  SwiftUIView.swift
//  SplitViewSettings
//
//  Created by Jacek Kosinski U on 10/03/2024.
//

import SwiftUI


struct SettingsSplitView2: View {
    /// show all columns, side by side
    @State private var visibility: NavigationSplitViewVisibility = .all

    var body: some View {
        NavigationSplitView(columnVisibility: $visibility) {
            SettingsSidebarView_()
        } detail: {

        }
        // the next modifier also modifies the list style of SettingsSidebarView
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview {
    return SettingsSplitView2()
}
