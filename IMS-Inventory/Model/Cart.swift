//
//  DatabaseModel.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/12/5.
//

import UIKit

struct RackingDatabase {
    
    struct Response: Codable {
        let records: [Record]
    }
    
    struct Record: Codable {
        let id: String
        let createdTime: String
        let fields: Fields
    }

    struct Fields: Codable {
        let qty: Int?
        let articleName: String?
        let category: String?
        let articleNumber: String?
        let image: [ImageInfo]?
        
        enum CodingKeys: String, CodingKey {
            case qty = "Qty"
            case articleName
            case category = "Category"
            case articleNumber
            case image
        }
    }

    struct ImageInfo: Codable {
        let id: String
        let width: Int
        let height: Int
        let url: String
        let filename: String
        let size: Int
        let type: String
        let thumbnails: Thumbnails
    }

    struct Thumbnails: Codable {
        let small: ThumbnailInfo
        let large: ThumbnailInfo
        let full: ThumbnailInfo
    }

    struct ThumbnailInfo: Codable {
        let url: String
        let width: Int
        let height: Int
    }
}
