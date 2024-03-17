//
//  ApllicationDetailsView.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 17/03/2024.
//

import SwiftUI

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

                    case .tab(let tab):
                        tab.tabContent
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

//#Preview {
//    ApplicationDetailView()
//}
