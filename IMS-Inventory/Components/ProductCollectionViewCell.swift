//
//  ProductCollectionViewCell.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/5/18.
//

import UIKit
import UIView_Shimmer

class ProductCollectionViewCell: UICollectionViewCell, ShimmeringViewProtocol {
    
    static let identifier: String = "ProductCollectionViewCell"
    
    static func scriptFont(size: CGFloat) -> UIFont {
      guard let customFont = UIFont(name: "NotoIKEATraditionalChinese-Bold", size: size) else {
        return UIFont.systemFont(ofSize: size)
      }
      return customFont
    }
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.fill")
        imageView.backgroundColor = Colors.white
        imageView.tintColor = Colors.IKEA_Blue
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let articleNumberTextView: UITextView = {
        let textView = UITextView()
        textView.text = "No.10150"
        textView.textColor = Colors.white // 使用系統顏色代替自定義顏色
        textView.font = scriptFont(size: 15)
        textView.backgroundColor = Colors.black
        textView.textColor = Colors.white
        textView.layer.cornerRadius = 2
        textView.textContainerInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        textView.clipsToBounds = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let productTCNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textColor = Colors.CustomTitleColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productENNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textColor = Colors.lightGray // 使用系統顏色代替自定義顏色
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let qtyLabel: UILabel = {
        let label = UILabel()
        label.text = "庫存數: "
        label.textColor = Colors.CustomTitleColor // 使用系統顏色代替自定義顏色
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var shimmeringAnimatedItems: [UIView] {
        [
            productImageView,
            articleNumberTextView,
            productENNameLabel,
            productTCNameLabel
        ]
    }
    
    // MARK: - Override init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    // MARK: - prepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepareForReuse")
    }
    
    // MARK: - required init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up UI:
    func setupUI() {
        contentView.addSubview(productImageView)
        contentView.addSubview(labelStackView)
        configLabelsStackView()
        addConstraints()
    }
    
    func configLabelsStackView() {
        labelStackView.addArrangedSubview(productTCNameLabel)
        labelStackView.addArrangedSubview(productENNameLabel)
        labelStackView.addArrangedSubview(articleNumberTextView)
        labelStackView.addArrangedSubview(qtyLabel)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            productImageView.widthAnchor.constraint(equalToConstant: 150),
            productImageView.heightAnchor.constraint(equalToConstant: 150),
            
            labelStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 20),
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            labelStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -30)
        ])
    }
}

#Preview(traits: .fixedLayout(width: 420, height: 170), body: {
    let prodictCollectionViewCell: UICollectionViewCell = ProductCollectionViewCell()
    return prodictCollectionViewCell
})
