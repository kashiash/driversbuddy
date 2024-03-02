//
//  ContentView.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 02/03/2024.
//

import SwiftUI

struct ContentView: View {

    @State var showSheet = false
    var body: some View {
        TabView {
            ForEach(Tab.allCases, id: \.rawValue) {
                tab in
                Text(tab.rawValue)
                    .tag(tab)
                    .tabItem {
                        Image(systemName: tab.symbol)
                        Text(tab.rawValue)
                    }
            }
        }
        .task{
            showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            VStack(alignment: .leading,spacing: 10, content: {
                Text("Test")
            })
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .presentationDetents([.height(60), .medium,.large])
            .presentationCornerRadius(20)
            .presentationBackground(.regularMaterial)
            .presentationBackgroundInteraction(.enabled(upThrough: .large))
            .bottomMaskForSheet()
        }
    }
}

#Preview {
    ContentView()
}
