//
//  PrivateData.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/10/21.
//

import UIKit

struct API {
    private init() {}
    static let baseUrl               = URL(string: "https://api.airtable.com/v0/app7877pVxbaMubQP/Racking_Info")!
    static let apiKey: String        = "patuJC6rtLI3iGdS1.87ac91b245f91e71624b0f7e001cc0d1a9e30bcfa3846f94a4d0e2d1e4241494"
    static let apiKeyBearerToken: String = "Bearer patuJC6rtLI3iGdS1.79bc27090cef6919d6b1adc031ca33afc7ff0f5da0bad7550a71ec870ab56c68"
    static let authorization: String = "Authorization"

    static let contentType: String   = "Content-Type"
    static let application: String   = "application/json"
    
    static let get_IMSDatabase_url = URL(string: "https://api.airtable.com/v0/app7877pVxbaMubQP/Racking_Database/")!
    static let delete_IMSDatabase_url = URL(string: "https://api.airtable.com/v0/app7877pVxbaMubQP/Racking_Database/recIV4mmRSgPkgODk")!
}
