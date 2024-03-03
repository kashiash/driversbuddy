//
//  ImportDataTests.swift
//  driverbuddyTests
//
//  Created by Jacek Kosinski U on 03/03/2024.
//

import XCTest
import SwiftCSV

final class ImportDataTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {


        let gistRawURL = "https://gist.githubusercontent.com/kashiash/54a66f7171a81bec767e96cdcb8d2212/raw/a0e74a0ec62a17c2741a8a23fb806d48aef5d13f/makes.csv"

        // Create a URL from the Gist Raw URL
        if let url = URL(string: gistRawURL) {
            do {
                // Download the CSV file content
                let csvContent = try String(contentsOf: url)
             //   print(csvContent)

                do {
                    // As a string, guessing the delimiter
                    let csv: CSV = try CSV<Named>(string: csvContent)


                    print(csv.header)
                    do {

                         try   csv.enumerateAsDict { dict in

                             var makeId = dict["'id_car_make'"]?.replacingOccurrences(of: "'", with: "")
                             var makeName = dict["'name'"]?.replacingOccurrences(of: "'", with: "")

                                print("\(makeId) \(makeName) ")
                            }
                        } catch {
                            print(error)
                        }
                    }

//                    csv.enumerateAsArray { array in
//                        print(array[0])
//                        print(array[1])
//                    }




              //  } catch parseError as CSVParseError {
                    // Catch errors from parsing invalid CSV
                } catch {
                   print(error)
                }
            }

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
