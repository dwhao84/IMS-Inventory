//
//  ProductImageCell.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/11/3.
//

import UIKit

class ProductImageCell: UITableViewCell {
    
    static let identifier: String = "ProductImageCell"
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.photoLibrary
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = Colors.black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(productImageView)
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with image: UIImage?) {
        productImageView.image = image
    }
}

#Preview(traits: .fixedLayout(width: 420, height: 250), body: {
    let productImageCell = ProductImageCell()
    return productImageCell
})
