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
    
    // MARK: - GET Product Data
    /**
     * MARK: - GET Product Data
     * Fetches product data from Airtable with pagination support
     * @param offset: Optional offset token for pagination
     * @param pageSize: Number of records per page (default: 20)
     */
    func getProductData(offset: String? = nil,
                       pageSize: Int = 20,
                       completion: @escaping(Result<([Record], String?), NetworkError>) -> Void) {
        // Construct URL with pagination parameters
        var components = URLComponents(string: API.baseUrl.absoluteString)
        var queryItems = [URLQueryItem]()
        
        // Add pageSize parameter
        queryItems.append(URLQueryItem(name: "pageSize", value: "\(pageSize)"))
        
        // Add offset if provided
        if let offset = offset {
            queryItems.append(URLQueryItem(name: "offset", value: offset))
        }
        
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            completion(.failure(.invalidResponse))
            return
        }
        
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
                // Return both records and offset for next page
                completion(.success((rackingData.records, rackingData.offset)))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        task.resume()
    }
    
    // MARK: - GET Borrow Return Data
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
    
    // MARK: - POST Borrow Return Data
    func createBorrowReturn(
        articleNumber: String,
        rackingDescription: String,
        orderNumber: String,
        status: String,
        rackingQty: Int,
        userName: String,
        imageUrl: String,
        completion: @escaping (Result<BorrowReturn.Response, NetworkError>) -> Void
    ) {
        // 日期格式設定
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let createdDate = dateFormatter.string(from: Date())
        
        // 創建請求體
        let postFields = BorrowReturn.PostFields(
            article_number: articleNumber,
            racking_description: rackingDescription,
            order_number: orderNumber,
            created_date: createdDate,
            status: status,
            racking_qty: rackingQty,
            imageUrl: imageUrl, user_name: userName
        )
        
        let postRecord = BorrowReturn.PostRecord(fields: postFields)
        let postRequest = BorrowReturn.PostRequest(records: [postRecord])
        
        // 創建請求
        var request = URLRequest(url: API.get_IMSDatabase_url)
        request.httpMethod = "POST"
        request.setValue(API.apiKeyBearerToken, forHTTPHeaderField: API.authorization)
        request.setValue(API.application, forHTTPHeaderField: API.contentType)
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(postRequest)
            request.httpBody = jsonData
            
            // Debug 信息
            print("POST URL: \(API.get_IMSDatabase_url)")
            print("Headers: \(String(describing: request.allHTTPHeaderFields))")
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Request Body: \(jsonString)")
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // 處理網絡錯誤
                if let error = error {
                    print("Network error: \(error.localizedDescription)")
                    completion(.failure(.networkError(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("Status code: \(httpResponse.statusCode)")
                
                // 檢查狀態碼
                guard (200...299).contains(httpResponse.statusCode) else {
                    if let data = data, let errorResponse = String(data: data, encoding: .utf8) {
                        print("Error response: \(errorResponse)")
                    }
                    completion(.failure(.invalidResponse))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(BorrowReturn.Response.self, from: data)
                    completion(.success(response))
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response data: \(responseString)")
                    }
                    completion(.failure(.decodingError(error)))
                }
            }
            task.resume()
            
        } catch {
            print("Encoding error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Delete Borrow Return Data
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

