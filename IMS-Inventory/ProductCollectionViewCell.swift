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
        imageView.layer.borderWidth = 0.2
        imageView.layer.borderColor = Colors.lightGray.cgColor
        imageView.tintColor = Colors.IKEA_Blue
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var articleNumberLabel: UILabel = {
        let label = UILabel()
        label.text = " No.10150 "
        label.textColor = Colors.white // 使用系統顏色代替自定義顏色
//        label.font = UIFont(name: "NotoIKEATraditionalChinese_Latin-Bold.ttf", size: 26)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = Colors.black
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var productENNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Wooden Shelf"
        label.textColor = Colors.darkGray // 使用系統顏色代替自定義顏色
//        label.font = UIFont(name: Fonts.NotoIKEA_TC_Bold, size: 20)
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var productTCNameLabel: UILabel = {
        let label = UILabel()
        label.text = "木層板"
        label.textColor = Colors.lightGray
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var qtyLabel: UILabel = {
        let label = UILabel()
        label.text = "庫存數"
        label.textColor = Colors.black // 使用系統顏色代替自定義顏色
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
    
    var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepareForReuse")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.addSubview(productImageView)
        self.addSubview(labelStackView)
        self.addSubview(qtyLabel)
        
        configStackView()
        addConstraints()
    }
    
    func configStackView() {
        articleNumberLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        qtyLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        qtyLabel.backgroundColor = Colors.IKEA_Blue
        
        labelStackView.addArrangedSubview(productImageView)
        labelStackView.addArrangedSubview(articleNumberLabel)
        labelStackView.addArrangedSubview(productENNameLabel)
        labelStackView.addArrangedSubview(productTCNameLabel)
        
        mainStackView.addArrangedSubview(labelStackView)
        mainStackView.addArrangedSubview(qtyLabel)
        self.addSubview(mainStackView)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(equalToConstant: 150),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor, multiplier: 1),
            labelStackView.widthAnchor.constraint(equalToConstant: 150),
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            mainStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            
        ])
    }
    
    private func configureCell () {
        
    }
}

#Preview(traits: .fixedLayout(width: 200, height: 300), body: {
    let prodictCollectionViewCell: UICollectionViewCell = ProductCollectionViewCell()
    return prodictCollectionViewCell
})
