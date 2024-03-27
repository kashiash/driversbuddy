//
//  SwiftUIView.swift
//  SwiftUITestApp
//
//  Created by Jacek Kosinski U on 26/03/2024.
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

    case fontPlayground
    case simpleFont
    case fontWeight
    case material
    case automobile

    var localized: String {
        self.rawValue
    }


    @ViewBuilder
    var tabContent: some View {
        switch self {
        case .fontPlayground:
            FontExamplesView()
        case .fontPlayground:
            FontSimpleExamplesView()
        case .fontWeight:
            FontWeightExamples()
        case .material:
            SwiftMaterialExamples()
        default:
            VStack{
                Text(self.localized)
            }
        }
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
