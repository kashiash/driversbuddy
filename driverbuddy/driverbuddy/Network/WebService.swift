//
//  WebService.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 03/03/2024.
//

import Foundation
import SwiftCSV
import SwiftData


class WebService {
    @MainActor
    func updateCarMakeDataInDatabase(modelContext: ModelContext) async {
        do {

            let gistRawURL = "https://gist.githubusercontent.com/kashiash/54a66f7171a81bec767e96cdcb8d2212/raw/a0e74a0ec62a17c2741a8a23fb806d48aef5d13f/makes.csv"

            if let url = URL(string: gistRawURL) {
                do {
                    let csvContent = try String(contentsOf: url)
                    let csv: CSV = try CSV<Named>(string: csvContent)
                    try   csv.enumerateAsDict { dict in
                        if  let makeIdString = dict["'id_car_make'"]?.replacingOccurrences(of: "'", with: "") {
                            let makeId = Int(makeIdString)
                            let makeName = dict["'name'"]?.replacingOccurrences(of: "'", with: "")

                            if let makeId, let makeName {
                                print("\(makeId) \(makeName) ")

                                let itemToStore = CarMake(makeId:  makeId, name: makeName)
                                modelContext.insert(itemToStore)
                            }
                        }
                    }
                }
            }
        } catch {
            print("Error fetching data")
            print(error.localizedDescription)
        }
    }

    @MainActor
    func updateCarModelDataInDatabase(modelContext: ModelContext) async {
        do {

        let modelsUrl = URL(string: "https://gist.githubusercontent.com/kashiash/cb020f31991328be05998fbb2e450731/raw/29e8617c9a51ceeaa7b695b318d5dc03fbe8ebfc/models.csv")!

        let httpClient = HTTPClient()

        let resource = Resource(url: modelsUrl,modelType: String.self)


         let   resultString = try await httpClient.load(resource)

         //   print("CSV Content:\n\(resultString)")



        let csv: CSV = try CSV<Named>(string: resultString)
        print("pobrano: \(csv.rows)")

        try   csv.enumerateAsDict { dict in
            if  let makeIdString = dict["'id_car_make'"]?.replacingOccurrences(of: "'", with: ""),
                let modelIdString = dict["'id_car_model'"]?.replacingOccurrences(of: "'", with: ""),
                let modelName = dict["'name'"]?.replacingOccurrences(of: "'", with: ""),

                    let makeId = Int(makeIdString),
                let modelId = Int(modelIdString)

            {
                print("\(makeId) \(modelId) \(modelName) ")
                do {
                    let make = try modelContext.existingMake(for: makeId)
                    if let make {
                        let itemToStore = CarModel(modelId: modelId, name: modelName, make: make)
                        modelContext.insert(itemToStore)
                    }
                } catch {
                    print("Error saving data")
                    print(error.localizedDescription)
                }
            }

        }

        } catch {
            print("Error fetching data")
            print(error.localizedDescription)
        }

    }


    @MainActor
    func updateCarModelDataInDatabasexx(modelContext: ModelContext) async {
        do {

            let gistRawURL = "https://gist.githubusercontent.com/kashiash/cb020f31991328be05998fbb2e450731/raw/f31f9a349b47a0879ffc00fc8f6240f68781872e/models.csv"

            if let url = URL(string: gistRawURL) {
                do {
                    let csvContent = try  String(contentsOf: url)

                    let csv: CSV = try CSV<Named>(string: csvContent)
                    try   csv.enumerateAsDict { dict in
                        if  let makeIdString = dict["'id_car_make'"]?.replacingOccurrences(of: "'", with: ""),
                            let modelIdString = dict["'id_car_model'"]?.replacingOccurrences(of: "'", with: ""),
                            let makeName = dict["'name'"]?.replacingOccurrences(of: "'", with: ""),

                                let makeId = Int(makeIdString),
                            let modelId = Int(modelIdString)
                                
                        {
                            print("\(makeId) \(makeName) ")
                            do {
                                let make = try modelContext.existingMake(for: makeId)
                                if let make {
                                    let itemToStore = CarModel(modelId: modelId, name: makeName, make: make)
                                    modelContext.insert(itemToStore)
                                }
                            } catch {
                                print("Error saving data")
                                print(error.localizedDescription)
                            }


                        }

                    }
                }
            }
        } catch {
            print("Error fetching data")
            print(error.localizedDescription)
        }
    }

}

extension ModelContext {
    func existingModel<T>(for objectID: PersistentIdentifier)
    throws -> T? where T: PersistentModel {
        if let registered: T = registeredModel(for: objectID) {
            return registered
        }

        let fetchDescriptor = FetchDescriptor<T>(
            predicate: #Predicate {
                $0.persistentModelID == objectID
            })

        return try fetch(fetchDescriptor).first
    }


    func existingMake(for makeID: Int) throws -> CarMake? {
        let fetchDescriptor = FetchDescriptor<CarMake>(
            predicate: #Predicate {
                $0.makeId == makeID
            })

        return try fetch(fetchDescriptor).first
    }
}
