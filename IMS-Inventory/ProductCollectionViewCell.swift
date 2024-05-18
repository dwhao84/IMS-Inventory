//
//  ProductCollectionViewCell.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/5/18.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "ProductCollectionViewCell"
    
    var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.fill")
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.red.cgColor
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var productENNameLabel: UILabel = {
        let label = UILabel()
        label.text = "XXXX"
        label.textColor = .darkGray // 使用系統顏色代替自定義顏色
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var productTCNameLabel: UILabel = {
        let label = UILabel()
        label.text = "XXXX"
        label.textColor = .lightGray // 使用系統顏色代替自定義顏色
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var articleNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "10000"
        label.textColor = .black // 使用系統顏色代替自定義顏色
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var qtyLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textColor = .black // 使用系統顏色代替自定義顏色
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(productImageView)
        self.addSubview(labelStackView)
        configLabelStackView()
        addConstraints()
    }
    
    private func configLabelStackView() {
        labelStackView.addArrangedSubview(articleNumberLabel)
        labelStackView.addArrangedSubview(productENNameLabel)
        labelStackView.addArrangedSubview(productTCNameLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            // Image View Constraints
            productImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            productImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            productImageView.heightAnchor.constraint(equalToConstant: 140),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),
            
            // Stack View Constraints
            labelStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            labelStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            labelStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
}

#Preview(traits: .fixedLayout(width: 428, height: 150), body: {
    let prodictCollectionViewCell: UICollectionViewCell = UICollectionViewCell()
    return prodictCollectionViewCell
})
