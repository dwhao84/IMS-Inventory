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
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Using Date"
        label.textColor = Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let datePicker: UIDatePicker = {
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.date = .now
        datePicker.locale = .current
        datePicker.minimumDate = .now
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    } ()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI () {
        contentView.addSubview(datePicker)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            datePicker.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
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

