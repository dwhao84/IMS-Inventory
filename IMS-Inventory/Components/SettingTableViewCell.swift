//
//  SettingTableViewCell.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/10/31.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    static let identifier: String = "SettingTableViewCell"

    let iconImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = Images.gear
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    let serviceTitle: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = Colors.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    let stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 30
        return stackView
    } ()
    
    // MARK: - override init:
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        contentView.backgroundColor = Colors.clear
        addStackView()
        addConstraints()
    }
    
    // MARK: - required init:
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addStackView() {
        iconImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(serviceTitle)
        contentView.addSubview(stackView)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

#Preview(traits: .fixedLayout(width: 428, height: 80), body: {
    let settingTableViewCell: UITableViewCell = SettingTableViewCell()
    return settingTableViewCell
})
