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
    static let apiKey: String        = "patXaY8Vhmqi3dtB6.93b9b04767d52acf0c66e9df2ec67db7901bd05f0485cf77cc19f2ca2fc17d65"
    static let authorization: String = "Authorization"
}
