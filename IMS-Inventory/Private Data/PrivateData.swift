//
//  PrivateData.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/10/21.
//

import UIKit

struct API {
    private init() {}
    static let baseUrl = URL(string: "https://api.airtable.com/v0/app7877pVxbaMubQP/Racking_Qty?maxRecords=1000&view=Grid%20view")!
    static let apiKey = "pat1LqVaDimhjw3Zf.b43913585307f91de54e59d08120eb228c2d09c777a0c10250ba3a5aab67bcf4"
}
