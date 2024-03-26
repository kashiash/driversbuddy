//
//  SwiftUIView.swift
//  SwiftUITestApp
//
//  Created by Jacek Kosinski U on 26/03/2024.
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
                        HStack {
                            Text("To nie tu")
                        }

                    case .mode(let mode):
                        mode.tabContent
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
