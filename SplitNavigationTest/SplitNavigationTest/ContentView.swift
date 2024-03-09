//
//  ContentView.swift
//  SplitNavigationTest
//
//  Created by Jacek Kosinski U on 08/03/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var firstSelectedDataItem: DataModel?
    @State private var firstTabSelectedDataItem: Tab?
    @State private var secondSelectedDataItem: DataModel?
    @State private var thirdSelectedDataItem: DataModel?

    var body: some View {
        NavigationSplitView {
            VStack {
                List(SampleData.firstScreenData, selection: $firstSelectedDataItem) { item in
                    NavigationLink(item.text, value: item)
                }

                List(Tab.allCases, selection: $firstTabSelectedDataItem) { tab in
                    NavigationLink(tab.rawValue, value: tab)
                }
            }
            .navigationTitle("Sidebar")
        } content: {
            VStack(alignment: .leading) {
                if firstSelectedDataItem != nil {
                    Text("Previously Selected Item: \(firstSelectedDataItem!.text)")
                }

                if firstTabSelectedDataItem != nil {
                    Text("Previously Selected Item: \(firstTabSelectedDataItem!.rawValue)")
                    firstTabSelectedDataItem?.tabContent
                } else {
                    List(SampleData.secondScreenData, selection: $secondSelectedDataItem) { item in
                        NavigationLink(item.text, value: item)
                    }
                    .navigationTitle("Content")
                }

            }.padding()
        } detail: {
            VStack(alignment: .leading) {
                if secondSelectedDataItem != nil {
                    Text("Previously Selected Item: \(secondSelectedDataItem!.text)")
                        .padding()
                }
                List(SampleData.lastScreenData, selection: $thirdSelectedDataItem) { item in
                    Text(item.text)
                }
            }
            .navigationTitle("Detail")
        }
    }
}

#Preview {
    ContentView()
}
