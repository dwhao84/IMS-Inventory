//
//  NetworkManagers.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/11/28.
//

import UIKit

class NetworkManager {
    private init() {}
    static let shared = NetworkManager()
    
    enum NetworkError: Error {
        case networkError(Error)
        case invalidResponse
        case noData
        case decodingError(Error)
    }
    
    func getProductData(completion: @escaping(Result<[Record], NetworkError>) -> Void) {
        let url = API.baseUrl
        var request = URLRequest(url: url)
        request.setValue("Bearer \(API.apiKey)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Response: \(String(describing: response))")
                completion(.failure(.invalidResponse))
                return
            }

            print("Status code: \(httpResponse.statusCode)")
            print("Headers: \(httpResponse.allHeaderFields)")
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON Response:", jsonString)
                }
                let rackingData = try decoder.decode(RackingData.self, from: data)
                completion(.success(rackingData.records))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
    

    
    
}
