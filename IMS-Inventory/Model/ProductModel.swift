//
//  ProductModel.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/5/18.

// MARK: - RackingData
struct RackingData: Codable {
    let records: [Record]
    let offset: String
}

struct Record: Codable {
    let id: String
    let createdTime: String
    let fields: Fields
}

struct Fields: Codable {
    let image: [Image]
    let articleName: String
    let articleNumber: String
    let category: Category?
    let Qty: Int  // Changed from qty to Qty to match API response case
}

enum Category: String, Codable {
    case communication = "communication"
    case desksCounters = "desks_counters"
    case ikeaFOODEquipment = "ikea_FOOD_equipment"
    case lighting = "lighting"
    case merchandisingDisplay = "merchandising_display"
    case productAreaSpecific = "product_area_specific"
    case shoppingExperience = "shopping_experience"
    case tradeDress = "trade_dress"
}

struct Image: Codable {
    let id: String
    let width: Int
    let height: Int
    let url: String
    let filename: String
    let size: Int
    let type: ImageType
    let thumbnails: Thumbnails
}

struct Thumbnails: Codable {
    let small: ImageSize
    let large: ImageSize
    let full: ImageSize
}

struct ImageSize: Codable {
    let url: String
    let width: Int
    let height: Int
}

enum ImageType: String, Codable {
    case jpeg = "image/jpeg"
}
