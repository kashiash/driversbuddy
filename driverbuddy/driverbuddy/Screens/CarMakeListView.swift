//
//  MakeListView.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 03/03/2024.
//

import SwiftUI
import SwiftData

struct CarMakeListView: View {


    @Environment(\.modelContext) var modelContext
    @Query(sort: \CarMake.name) var carMakes: [CarMake]

    var body: some View {
        NavigationStack {
            List {
                ForEach(carMakes) { make in
                    Text(make.name)
                }
            }
        }
        .task {
            if carMakes.isEmpty {
                await WebService().updateCarMakeDataInDatabase(modelContext: modelContext)
            }
        }
    }
}

#Preview {
    CarMakeListView()
}
