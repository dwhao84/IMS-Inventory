//
//  CartTableViewCell.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/12/2.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    static let identifier: String = "CartTableViewCell"
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.photoLibrary
        imageView.backgroundColor = Colors.white
        imageView.tintColor = Colors.black
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let statusLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Status"
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = Colors.darkGray
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    let dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Date Label"
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = Colors.darkGray
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    // MARK: - Random Number
    let orderNumberLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "# Random Number"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    let articleNumberLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Loading..."
        label.textColor = Colors.white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.backgroundColor = Colors.black
        label.textAlignment = .center
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productENNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textColor = Colors.lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "User"
        label.textColor = Colors.black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let qtyLabel: UILabel = {
        let label = UILabel()
        label.text = "Qty: Loading..."
        label.textColor = Colors.darkGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = Colors.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = UIImage(systemName: "photo.fill")
        productENNameLabel.text = "Loading..."
        articleNumberLabel.text = "Loading..."
        qtyLabel.text = "Qty: "
    }
    
    private func setupUI() {
        contentView.backgroundColor = Colors.white
        contentView.addSubview(productImageView)
        contentView.addSubview(labelStackView)
        configLabelsStackView()
        addConstraints()
    }
    
    private func configLabelsStackView() {
        labelStackView.addArrangedSubview(orderNumberLabel)
        labelStackView.addArrangedSubview(userNameLabel)
        labelStackView.addArrangedSubview(statusLabel)
        labelStackView.addArrangedSubview(articleNumberLabel)
        labelStackView.addArrangedSubview(productENNameLabel)
        labelStackView.addArrangedSubview(qtyLabel)
        labelStackView.addArrangedSubview(dateLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productImageView.widthAnchor.constraint(equalToConstant: 120),
            productImageView.heightAnchor.constraint(equalToConstant: 108),
            
            labelStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            labelStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            labelStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 16),
            labelStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            
            articleNumberLabel.widthAnchor.constraint(lessThanOrEqualTo: labelStackView.widthAnchor, multiplier: 0.8),
            productENNameLabel.widthAnchor.constraint(equalTo: labelStackView.widthAnchor),
        ])
    }
}


#Preview(traits: .fixedLayout(width: 420, height: 180), body: {
    let cartTableViewCell = CartTableViewCell()
    return cartTableViewCell
})

