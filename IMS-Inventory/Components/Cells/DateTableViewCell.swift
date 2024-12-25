//
//  DateTableViewCell.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/12/2.
//

import UIKit

class DateTableViewCell: UITableViewCell {
    
    static let identifier: String = "DateTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.text = "Using Date"
        label.lineBreakMode = .byTruncatingTail
        label.textColor = Colors.black
//        label.layer.borderColor = UIColor.black.cgColor
//        label.layer.borderWidth = 0.2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let datePicker: UIDatePicker = {
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.date = .now
        datePicker.locale = .current
        datePicker.minimumDate = .now
//        datePicker.layer.borderColor = UIColor.black.cgColor
//        datePicker.layer.borderWidth = 0.2
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    } ()
    
    private let stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI () {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(datePicker)
        
        datePicker.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(lessThanOrEqualTo: contentView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(lessThanOrEqualTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10),
        ])
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
}

#Preview(traits: .fixedLayout(width: 420, height: 100), body: {
    let dateTableViewCell = DateTableViewCell()
    return dateTableViewCell
})

