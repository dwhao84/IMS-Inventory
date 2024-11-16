//
//  ProductInfoCell.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/11/16.
//

import UIKit

class ProductInfoCell: UITableViewCell {
    
    private let articleNumberLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textColor = Colors.white
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.backgroundColor = Colors.black
        label.textAlignment = .center
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(articleNumberLabel)
        NSLayoutConstraint.activate([
            articleNumberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            articleNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            articleNumberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(articleNumber: String) {
        articleNumberLabel.text = articleNumber
    }
}
