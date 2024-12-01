//
//  CustomNavigationTitleView.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/12/2.
//

// CustomNavigationTitleView.swift
import UIKit

class CustomNavigationTitleView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.black
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 初始化方法
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            // 設置標題標籤的約束
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor), // 靠左對齊
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor), // 垂直置中
            
            // 設置視圖本身的寬度
            self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 50)
        ])
    }
    
    // 提供一個方法來更新標題
    func updateTitle(_ title: String) {
        titleLabel.text = title
    }
}
