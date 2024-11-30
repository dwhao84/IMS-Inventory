//
//  ConfirmButton.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/10/31.
//

import UIKit

class ConfirmButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = Colors.black
        config.baseForegroundColor = Colors.white
        config.title = "Send"
        config.cornerStyle = .capsule
        self.configuration = config
        self.translatesAutoresizingMaskIntoConstraints = false
        configurationUpdateHandler = { btn in
            btn.alpha = btn.isHighlighted ? 0.5 : 1
            btn.configuration = config
        }
    }
}
