//
//  CarModelListView.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 03/03/2024.
//

import SwiftUI
import SwiftData

struct CarModelListView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \CarModel.name) var carModel: [CarModel]


    var body: some View {
        NavigationStack {
            List {
                ForEach(carModel) { model in
                    Text(model.make.Name)
                    Text(model.name)
                }
            }
        }
        .task {
            if carModel.isEmpty {
                await WebService().updateCarModelDataInDatabase(modelContext: modelContext)
            }
        }
    }
}

#Preview {
    CarModelListView()
}
