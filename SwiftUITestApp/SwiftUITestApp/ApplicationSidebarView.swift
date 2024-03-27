//
//  SwiftUIView.swift
//  SwiftUITestApp
//
//  Created by Jacek Kosinski U on 26/03/2024.
//

import SwiftUI

struct ApplicationSidebarView: View {

    @Binding var selectedDetail: SettingsDetail?


    @State private var notification: Bool = true

    var body: some View {
        List(selection: $selectedDetail) {

            Section(header: Text("fast actions")) {
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
