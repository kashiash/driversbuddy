//
//  ImportDataTests.swift
//  driverbuddyTests
//
//  Created by Jacek Kosinski U on 03/03/2024.
//

import XCTest
import SwiftCSV
@testable import driverbuddy


final class ImportDataTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetMakes() async throws {

        let makesUrl = URL(string: "https://gist.githubusercontent.com/kashiash/54a66f7171a81bec767e96cdcb8d2212/raw/a0e74a0ec62a17c2741a8a23fb806d48aef5d13f/makes.csv")!

        let httpClient = HTTPClient()

        let resource = Resource(url: makesUrl,modelType: String.self)


         let   resultString = try await httpClient.load(resource)

            print("CSV Content:\n\(resultString)")



            let csv: CSV = try CSV<Named>(string: resultString)


            print(csv.header)
           try csv.enumerateAsDict { dict in

                var makeId = dict["'id_car_make'"]?.replacingOccurrences(of: "'", with: "")
                var makeName = dict["'name'"]?.replacingOccurrences(of: "'", with: "")

               print("\(String(describing: makeId)) \(String(describing: makeName)) ")
            }



    }


    func testGetModels() async throws {

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

            }

        }



    }




    func testGetStations() async throws {
        let stationsUrl =  URL(string: "https://gist.githubusercontent.com/kashiash/ee74ce7dda606ccd02fc6ffeb8f8ad7e/raw/fb5a3e1bb6aedd1a5babfdf255f226da142a31ca/gistfile.txt")!  //add one
        let httpClient = HTTPClient()

        let resource = Resource(url: stationsUrl,modelType: String.self)


         let   resultString = try await httpClient.load(resource)

            print("CSV Content:\n\(resultString)")



            let csv: CSV = try CSV<Named>(string: resultString)


            print(csv.header)


        "Tankstelle;Werkstatt;Reinigung;Akz Nr.;Marke;Name;Land;ZIP;Ort;Anschrift;Telefon Nr;SELECT-Station;24h Service;DocStop;Nähe Autobahn;Autobahn TS;Autohof;Hochleistungszapfsäule;Sondertankpunkt;Aral Sondertankpunkt;UTA-Empfehlung;elektr. Führerscheinkontrolle;Parkplatz;Parkplatzbewachung;Restaurant;Imbiss;Fahrerwaschraum;GO Box Vertriebsstelle;Mautterminal;OBU Einbauservice;Automat ganz;Automat teilweise;AdBlue Kanister;AdBlue Zapfsäule;Autogas;Biodiesel;Erdgas;Pflanzenöl;Flüssigerdgas;HVO100;LKW Außenreinigung;Tankwagen Innenreinigung;Silofahrzeug Innenreinigung;Kühlfahrzeug Innenreinigung;Lebensmittelfahrzeug Innenreinigung;Geocodierung;Lieferantennr.;Supplier;Preiszone"
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
