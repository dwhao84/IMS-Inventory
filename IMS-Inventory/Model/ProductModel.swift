//
//  ProductModel.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/5/18.
//

// MARK: - Ims
struct Product: Codable {
    let records: [Record]
    let offset: String
}

// MARK: - Record
struct Record: Codable {
    let id: String
    let createdTime: CreatedTime
    let fields: Fields
}

enum CreatedTime: String, Codable {
    case the20231110T074642000Z = "2023-11-10T07:46:42.000Z"
    case the20231110T074940000Z = "2023-11-10T07:49:40.000Z"
    case the20231110T075736000Z = "2023-11-10T07:57:36.000Z"
}

// MARK: - Fields
struct Fields: Codable {
    let image: [Image]
    let articleName, articleNameInChinese, articleNumber: String
}

// MARK: - Image
struct Image: Codable {
    let id: String
    let width, height: Int
    let url: String
    let filename: String
    let size: Int
    let type: TypeEnum
    let thumbnails: Thumbnails
}

// MARK: - Thumbnails
struct Thumbnails: Codable {
    let small, large, full: Full
}

// MARK: - Full
struct Full: Codable {
    let url: String
    let width, height: Int
}

enum TypeEnum: String, Codable {
    case imageJPEG = "image/jpeg"
}
