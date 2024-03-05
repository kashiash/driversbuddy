//
//  File.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 04/03/2024.
//

import Foundation


enum NetworkError: Error {
    case badRequest
    case serverError(String)
    case decodingError
    case invalidResponse
}

extension NetworkError: LocalizedError {

    var errorDescription: String? {
        switch self {

        case .badRequest:
            return NSLocalizedString("Unable to perform request", comment: "badRequestError")
        case .serverError(let errorMessage):
            print(errorMessage)
            return NSLocalizedString(errorMessage, comment: "serverError")
        case .decodingError:
            return NSLocalizedString("Unable to decode successfully", comment: "decodingError")
        case .invalidResponse:
            return NSLocalizedString("Invalid response", comment: "invalidResponse")
        }
    }

}

enum HTTPMethod {
    case get([URLQueryItem])
    case post(Data?)
    case delete

    var name: String {
        switch self {
        case .get:
            return "GET"

        case .post:
            return "POST"

        case .delete:
            return "DELETE"
        }
    }
}

struct Resource<T: Codable> {
    let url: URL
    var method: HTTPMethod = .get([])
    var modelType: T.Type
}

struct HTTPClient {

    private var defaultHeaders: [String: String] {
        var headers = ["Content-Type": "application/json"]
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "authToken") else {
            return headers
        }
        headers["Authorization"] = "Bearer \(token)"
        return headers

    }
    func load <T: Codable>(_ resource: Resource<T>) async throws -> T {

        var request = URLRequest(url: resource.url)

      //  print(resource.url)
        switch resource.method {

        case .get(let queryItems):
            var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems

        case .post(let data):
            request.httpMethod = resource.method.name
            request.httpBody = data
        case .delete:
            request.httpMethod = resource.method.name
        }

        let configuration = URLSessionConfiguration.default

        configuration.httpAdditionalHeaders = defaultHeaders
        let session = URLSession(configuration: configuration)

        // Print the request headers
//        if let headers = request.allHTTPHeaderFields {
//            print("Request Headers:")
//            headers.forEach { key, value in
//                print("\(key): \(value)")
//            }
//        }


        let (data,response) = try await session.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            let headers = httpResponse.allHeaderFields
//            print("Response Headers:")
//            headers.forEach { key, value in
//                print("\(key): \(value)")
//            }

            // Now you can use the 'data' and 'httpResponse' as needed
            // ...
        }

        guard let _ = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

      //  print("data \(String(bytes: data, encoding: .utf8)!)")

        if T.self is any StringProtocol.Type {
            guard let result = String(bytes: data, encoding: .utf8)  else {
                throw NetworkError.decodingError
            }
            return result as! T
        } else {
            guard let result = try? JSONDecoder().decode(resource.modelType, from: data) else {
                throw NetworkError.decodingError
            }
            return result
        }


    }
}
