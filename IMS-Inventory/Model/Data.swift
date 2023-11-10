//
//  Data.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2023/11/10.
//

import UIKit

struct Ims: Encodable {
    var records: [Record]

    struct Record: Encodable {
        var fields: Fields
    }

    struct Fields: Encodable {
        var articleNumber:        String
        var articleName:          String
        var articleNameInChinese: String
        var image:                [ImageData]
    }

    struct ImageData: Encodable {
        var url: URL
    }
}

