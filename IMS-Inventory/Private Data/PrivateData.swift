//
//  PrivateData.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/10/21.
//

import UIKit

struct API {
    private init() {}
    
    // Base URLs
    static let baseUrl = URL(string: "https://api.airtable.com/v0/app7877pVxbaMubQP/Racking_Info")!
    static let get_IMSDatabase_url = URL(string: "https://api.airtable.com/v0/app7877pVxbaMubQP/Racking_Database/")!
    static let delete_IMSDatabase_url = URL(string: "https://api.airtable.com/v0/app7877pVxbaMubQP/Racking_Database/recIV4mmRSgPkgODk")!
    
    // API Authentication - 直接使用完整的 Bearer Token
    static let apiKey = "patuJC6rtLI3iGdS1.87ac91b245f91e71624b0f7e001cc0d1a9e30bcfa3846f94a4d0e2d1e4241494"
    static let apiKeyBearerToken = "Bearer patuJC6rtLI3iGdS1.87ac91b245f91e71624b0f7e001cc0d1a9e30bcfa3846f94a4d0e2d1e4241494"
    
    // Header Keys
    static let authorization = "Authorization"
    static let contentType = "Content-Type"
    static let application = "application/json"
}
