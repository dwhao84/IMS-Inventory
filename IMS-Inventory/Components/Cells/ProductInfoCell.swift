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
        label.textAlignment = .center
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rackingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 2
        label.showsExpansionTextWhenTruncated = true
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
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
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.spacing = 10
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
        // Add labels to stack view
        stackView.addArrangedSubview(rackingLabel)
        stackView.addArrangedSubview(articleNumberLabel)

        
        // Add stack views to mainStackView
        mainStackView.addArrangedSubview(stackView)
        mainStackView.addArrangedSubview(qtyLabel)
        
        // Add mainStackView to contentView
        contentView.addSubview(mainStackView)
        
        // Define constraints
        NSLayoutConstraint.activate([
            // Main stack view constraints
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            mainStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Article number label width constraint
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
    productInfoCell.configure(articleNumber: "12081", rackingText: "CLIP FOR DISPLAY PANEL", qtyText: "Qty：50")
    return productInfoCell
})
