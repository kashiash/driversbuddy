//
//  VehicleDetailView.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 04/03/2024.
//

import SwiftUI
import SwiftData

struct VehicleDetailView: View {
    let vehicle: Vehicle
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var isEditing = true

    @State private var name: String = ""
    @State private var plate: String = ""
    @State private var year: Int? = nil
    @State private var testString: String = "Lorem ipsum"



    init(vehicle: Vehicle) {
        self.vehicle = vehicle
        self._name  = State.init(initialValue: vehicle.name)
        self._plate = State.init(initialValue: vehicle.plate)
        self._year  = State.init(initialValue: vehicle.year)
    }

    var body: some View {
        Form {

            if isEditing {

                VStack(alignment: .trailing) {
                    TextInputField("Vehicle Name",text: $name)
                        .clearButtonHidden(false)

                    TextInputField("Make",  text: $plate)
                        .clearButtonHidden(false)

                    TextInputField("Make",  text: $testString)
                        .clearButtonHidden(false)

                }
             //   .textFieldStyle(.roundedBorder)


                Button("Save") {

                }
            }
            else {
                Section("Vehicle") {

                    Text(vehicle.name)
                    Text(vehicle.fuelType.rawValue)
                    Text(String(vehicle.year))
                    Text(vehicle.plate)
                    Text(vehicle.make?.name ?? "no data")
                    Text(vehicle.model?.name ?? "no data")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    isEditing.toggle()
                }
            }
        }
        .navigationTitle("Vehicle Detail")
    }
}



#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Vehicle.self, configurations: config)

        let sampleMake = CarMake(makeId: 1, name: "DeLorean")
        container.mainContext.insert(sampleMake)
        let sampleModel = CarModel(modelId: 1, name: "DMC-12", make: sampleMake)
        container.mainContext.insert(sampleModel)


        let sampleObject2 = Vehicle(pressureUnits: PresureUnit.psi
                                    , plate: "WT 7446"
                                    , consumptionUnits: ConsumptionUnit.kmPerLiter
                                    , year: 2008
                                    , trim: nil
                                    , creationDate: .now
                                    , name: "Silver Hornet"
                                    , units: Units.km
                                    , insurance: "PZU"
                                    , type: VehicleType.car
                                    , tpFront: 5
                                    , tpRear: 5
                                    , status: Status.active
                                    , fuelUnits: FuelUnit.liters
                                    , make: sampleMake
                                    , model: sampleModel
                                    , vin: "JHFJFHKJHF666KJFHKJHFKFLKFJKJFLKF"
                                    , fuelType: FuelType.hybrid
                                    , notes: "Wóz drabiniasty"
                                    , registration: "prezydent miasta Pcim")
        container.mainContext.insert(sampleObject2)

        return VehicleDetailView(vehicle: sampleObject2)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}




