//
//  ProductInfoCell.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/11/16.
//

import UIKit

class ProductInfoCell: UITableViewCell {
    
    static let identifier = "ProductInfoCell"
    
    private let articleNumberLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textColor = Colors.white
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.backgroundColor = Colors.black
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rackingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingHead
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let qtyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = Colors.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(rackingLabel)
        stackView.addArrangedSubview(articleNumberLabel)
        stackView.addArrangedSubview(qtyLabel)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            // rackingLabel constraints
            rackingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            rackingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rackingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // stackView constraints - 與 rackingLabel 保持相同對齊
            stackView.topAnchor.constraint(equalTo: rackingLabel.bottomAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: rackingLabel.leadingAnchor), // 與 rackingLabel 左對齊
            stackView.trailingAnchor.constraint(equalTo: rackingLabel.trailingAnchor), // 與 rackingLabel 右對齊
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            // articleNumberLabel 固定寬度
            articleNumberLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func configure(articleNumber: String, rackingText: String, qtyText: String) {
        articleNumberLabel.text = articleNumber
        rackingLabel.text = rackingText
        qtyLabel.text = qtyText
    }
}

#Preview(traits: .fixedLayout(width: 420, height: 120), body: {
    let productInfoCell = ProductInfoCell()
    productInfoCell.configure(
        articleNumber: "10168",
        rackingText: "SHELF WOOD W 50MM LEDGE W600 D800MM WHI",
        qtyText: "Stock Qty: 1"
    )
    return productInfoCell
})
