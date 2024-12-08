//
//  DatabaseModel.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/12/5.
//

import UIKit

enum BorrowReturn {
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
        
        enum CodingKeys: String, CodingKey {
            case articleNumber = "article_number"
            case rackingDescription = "racking_description"
            case orderNumber = "order number"
            case createdDate = "created date"
            case status
            case rackingQty = "racking qty"
        }
    }
}
