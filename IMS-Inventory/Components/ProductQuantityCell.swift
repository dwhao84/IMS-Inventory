//
//  ProductQuantityCell.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/11/4.
//

import UIKit

class ProductQuantityCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.value = 1
        stepper.minimumValue = 1
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(stepper)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            stepper.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stepper.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
        stepper.isHidden = true
    }
    
    func configureWithStepper(title: String, value: Int, action: @escaping (UIStepper) -> Void) {
        titleLabel.text = title
        valueLabel.text = "\(value)"
        stepper.value = Double(value)
        stepper.isHidden = false
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        stepperAction = action
    }
    
    private var stepperAction: ((UIStepper) -> Void)?
    
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        valueLabel.text = "\(Int(sender.value))"
        stepperAction?(sender)
    }
}

#Preview(traits: .fixedLayout(width: 420, height: 170), body: {
    let productQuantityCell = ProductQuantityCell()
    return productQuantityCell
})
