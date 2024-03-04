//
//  VehicleCellView.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 04/03/2024.
//

import SwiftUI
import SwiftData

struct VehicleCellView: View {

    let vehicle: Vehicle

    var body: some View {
        NavigationLink(value: vehicle) {
            VStack(alignment: .leading) {
                    HStack {
                        Text(vehicle.name).font(.title)
                        Spacer()
                        Text(vehicle.fuelType.rawValue).font(.caption)
                    }
                    HStack {
                        Text(String(vehicle.year)).font(.caption).fontWeight(.bold)
                        Spacer()
                        Text(vehicle.plate).font(.caption).fontWeight(.bold)
                        Spacer()
                        Text(vehicle.make?.name ?? "no data").font(.caption)
                        Text(vehicle.model?.name ?? "no data").font(.caption)
                    }
                }
        }
        .navigationDestination(for: Vehicle.self) { vehicle in
            VehicleDetailView(vehicle: vehicle)
        }
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

        let sampleObject = Vehicle(pressureUnits: PresureUnit.psi
                                   , plate: "GWI 5446"
                                   , consumptionUnits: ConsumptionUnit.kmPerLiter
                                   , year: 2013
                                   , trim: nil
                                   , creationDate: .now
                                   , name: "Pussy Wagon"
                                   , units: Units.km
                                   , insurance: "PZU"
                                   , type: VehicleType.car
                                   , tpFront: 5
                                   , tpRear: 5
                                   , status: Status.active
                                   , fuelUnits: FuelUnit.liters
                                   , make: sampleMake
                                   , model: sampleModel
                                   , vin: "JHFJFHKJHFKJ999FHKJHFKFLKFJKJFLKF"
                                   , fuelType: FuelType.hybrid
                                   , notes: "Wóz drabiniasty"
                                   , registration: "prezydent miasta Pcim")
        container.mainContext.insert(sampleObject)

        let sampleObject2 = Vehicle(pressureUnits: PresureUnit.psi
                                   , plate: "WT 7446"
                                   , consumptionUnits: ConsumptionUnit.kmPerLiter
                                   , year: 2008
                                   , trim: nil
                                   , creationDate: .now
                                   , name: "Złoty Szerszeń"
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

        return VehicleListView().modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
