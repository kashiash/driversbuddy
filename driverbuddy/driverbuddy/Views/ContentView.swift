//
//  ContentView.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 02/03/2024.
//

import SwiftUI
import MapKit

struct ContentView: View {

    @State var showSheet = false
    @State var activeTab: Tab = .stations

    var body: some View {
        ZStack(alignment: .bottom) {
            Map(initialPosition: .region(.palacKultury))
        }
            TabBar()
            .frame(height:49)
            .background(.regularMaterial)
        .task{
            showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            VStack(alignment: .leading,spacing: 10, content: {
                activeTab.tabContent
            })
         //   .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .presentationDetents([.height(60), .medium,.large])
            .presentationCornerRadius(20)
            .presentationBackground(.regularMaterial)
            .presentationBackgroundInteraction(.enabled(upThrough: .large))
            .interactiveDismissDisabled()
            .bottomMaskForSheet()
        }
    }

    //Tab Bar

    @ViewBuilder
    func TabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Button(action: {
                    activeTab = tab
                }, label: {
                    VStack {
                        Image(systemName: tab.symbol)
                            .font(.title2)
                        Text(tab.rawValue)
                            .font(.caption2)
                    }
                    .foregroundStyle(activeTab == tab ? Color.accentColor : .gray)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .contentShape(.rect)
                })
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    ContentView()
}
extension MKCoordinateRegion {
    static var palacKultury: MKCoordinateRegion {
        let center = CLLocationCoordinate2D(latitude: 52.2315, longitude: 21.0069)

        return .init(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
    }
}
