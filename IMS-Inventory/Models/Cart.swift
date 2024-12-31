import UIKit

enum BorrowReturn {
    // Response structures for GET requests
    struct Response: Codable {
        let records: [Record]
    }
    
    struct Record: Codable {
        let id: String
        let createdTime: String
        let fields: Fields
    }
    
    struct Fields: Codable {
        let articleNumber: String?
        let rackingDescription: String?
        let orderNumber: String?
        let createdDate: String?
        let status: String?
        let rackingQty: Int?
        let user_name: String?  // 改為可選型別
        let imageUrl: String?
        
        enum CodingKeys: String, CodingKey {
            case articleNumber = "article_number"
            case rackingDescription = "racking_description"
            case orderNumber = "order number"
            case createdDate = "created date"
            case status
            case rackingQty = "racking qty"
            case user_name = "user name"
            case imageUrl = "imageUrl"
        }
    }
    
    // Request structures for POST requests
    struct PostRequest: Codable {
        let records: [PostRecord]
    }
    
    struct PostRecord: Codable {
        let fields: PostFields
    }
    
    struct PostFields: Codable {
        let article_number: String
        let racking_description: String
        let order_number: String
        let created_date: String
        let status: String
        let racking_qty: Int
        let imageUrl: String
        let user_name: String
        
        enum CodingKeys: String, CodingKey {
            case article_number = "article_number"
            case racking_description = "racking_description"
            case order_number = "order number"
            case created_date = "created date"
            case status
            case racking_qty = "racking qty"
            case imageUrl = "imageUrl"
            case user_name = "user name"
        }
    }
}
