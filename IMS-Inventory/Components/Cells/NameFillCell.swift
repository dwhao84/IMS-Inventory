//
//  NameFillCell.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/12/8.
//

import UIKit

class NameFillCell: UITableViewCell {
    
    static let identifier: String = "NameFillCell"
    
    private let statusTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = Constants.fillYourName
        label.textColor = Colors.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField = {
        let tf: UITextField = UITextField()
        tf.placeholder = Constants.fillYourName
        tf.borderStyle = .roundedRect
        tf.textColor = Colors.black
        tf.rightViewMode = .always
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(statusTitleLabel)
        contentView.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            statusTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameTextField.leadingAnchor.constraint(lessThanOrEqualTo: statusTitleLabel.trailingAnchor, constant: 200),
            nameTextField.widthAnchor.constraint(equalToConstant: 150),
            nameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

#Preview(traits: .fixedLayout(width: 420, height: 100), body: {
    let nameFillCell = NameFillCell()
    return nameFillCell
})
