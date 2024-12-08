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
    
    // Network request function
    func getBorrowReturnData(completion: @escaping(Result<[BorrowReturn.Record], NetworkError>) -> Void) {
        let url = API.get_IMSDatabase_url
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
                let borrowReturnData = try decoder.decode(BorrowReturn.Response.self, from: data)
                completion(.success(borrowReturnData.records))
            } catch {
                print("Decoding error:", error)
                completion(.failure(.decodingError(error)))
            }
        }
        task.resume()
    }
    func deleteBorrowReturnData(recordId: String, completion: @escaping (Bool) -> Void) {
        // 確保 URL 包含記錄 ID
        let baseURL = API.delete_IMSDatabase_url
        let urlString = "\(baseURL)/\(recordId)"  // 加入記錄 ID
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(API.apiKey)", forHTTPHeaderField: "Authorization")
        
        print("Delete URL: \(url)")
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")
                print("Response Headers: \(httpResponse.allHeaderFields)")
                
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response body: \(responseString)")
                }
                
                // 成功狀態碼為 200-299
                let success = (200...299).contains(httpResponse.statusCode)
                completion(success)
                return
            }
            
            if let error = error {
                print("Network error: \(error)")
            }
            completion(false)
        }.resume()
    }
}

