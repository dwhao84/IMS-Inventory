//
//  StatusTableViewCell.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/12/3.
//

import UIKit

class StatusTableViewCell: UITableViewCell {

    static let identifier: String = "StatusTableViewCell"
    
    let statusPicker: [String] = ["Return", "Borrow"]
    
    private let statusTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = Constants.status
        label.textColor = Colors.black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let statusTextField: UITextField = {
        let tf: UITextField = UITextField()
        tf.text = ""
        tf.borderStyle = .roundedRect
        tf.isUserInteractionEnabled = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    private let statusPickerView: UIPickerView = {
        let pickerView: UIPickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    } ()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        print("override init StatusTableViewCell")
        
        setupUI ()
        
        statusPickerView.delegate = self
        statusPickerView.dataSource = self
        statusTextField.inputView = statusPickerView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI () {
        contentView.addSubview(statusTitleLabel)
        contentView.addSubview(statusTextField)
        NSLayoutConstraint.activate([
            statusTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statusTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusTextField.leadingAnchor.constraint(lessThanOrEqualTo: statusTitleLabel.trailingAnchor, constant: 200),
            statusTextField.widthAnchor.constraint(equalToConstant: 150),
        ])
    }
    
}

extension StatusTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statusPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statusPicker[row]
    }
    
    
}

#Preview(traits: .fixedLayout(width: 420, height: 100), body: {
    let statusTVC = StatusTableViewCell()
    return statusTVC
})
