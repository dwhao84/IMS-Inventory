//
//  PaddingLabel.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/10/31.
//

import UIKit

class PaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                     height: size.height + padding.top + padding.bottom)
    }
}
