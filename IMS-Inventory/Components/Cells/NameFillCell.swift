//
//  NameFillCell.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/12/8.
//

import UIKit


protocol NameFillDelegate: AnyObject {
    func NameFillCell(_ cell: UITableViewCell, didEnterText: String)
}

class NameFillCell: UITableViewCell, UITextFieldDelegate {
    
    weak var delegate: NameFillDelegate?
    
    static let identifier: String = "NameFillCell"
    
    private let statusTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = String(localized: "Fill your name")
        label.textColor = Colors.black
        label.textAlignment = .center
//        label.layer.borderWidth = 0.2
//        label.layer.borderColor = UIColor.black.cgColor
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField = {
        let tf: UITextField = UITextField()
        tf.placeholder = String(localized: "Fill your name")
        tf.borderStyle = .roundedRect
        tf.textColor = Colors.black
        tf.keyboardType = .default
//        tf.layer.borderColor = UIColor.black.cgColor
//        tf.layer.borderWidth = 0.2
        tf.clearButtonMode = .always
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    private let stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupUI()
        nameTextField.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        stackView.addArrangedSubview(statusTitleLabel)
        stackView.addArrangedSubview(nameTextField)
        contentView.addSubview(stackView)
        nameTextField.widthAnchor.constraint(equalToConstant: 350).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    // textField should return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("nameTextField Should Return")
        delegate?.NameFillCell(self, didEnterText: textField.text!)
        print(textField.text!)
        return true
    }
    // textField
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.becomeFirstResponder()
        print("nameTextField Did Change Selection")
        delegate?.NameFillCell(self, didEnterText: textField.text!)
        print(textField.text!)
    }
}

#Preview(traits: .fixedLayout(width: 420, height: 100), body: {
    let nameFillCell = NameFillCell()
    return nameFillCell
})
