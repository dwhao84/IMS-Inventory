import UIKit
class StatusTableViewCell: UITableViewCell {
    static let identifier: String = "StatusTableViewCell"
    
    let statusOptions: [String] = ["Return", "Borrow"]
    
    private let statusTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = Constants.status
        label.textColor = Colors.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.bordered()
        config.title = "Return"
        config.baseBackgroundColor = Colors.white
        config.baseForegroundColor = Colors.black
        config.background.strokeColor = Colors.black
        config.cornerStyle = .large
        config.background.strokeWidth = 1
        config.titleAlignment = .automatic
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupUI()
        configureMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(statusTitleLabel)
        contentView.addSubview(statusButton)
        
        NSLayoutConstraint.activate([
            statusTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            statusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusButton.leadingAnchor.constraint(lessThanOrEqualTo: statusTitleLabel.trailingAnchor, constant: 200),
            statusButton.widthAnchor.constraint(equalToConstant: 150),
            statusButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func configureMenu() {
        var menuActions: [UIAction] = []
        
        for option in statusOptions {
            let action = UIAction(title: option) { [weak self] action in
                self?.statusButton.setTitle(option, for: .normal)
            }
            menuActions.append(action)
        }
        
        statusButton.menu = UIMenu(children: menuActions)
        statusButton.showsMenuAsPrimaryAction = true
    }
}

#Preview(traits: .fixedLayout(width: 420, height: 100), body: {
    let statusTVC = StatusTableViewCell()
    return statusTVC
})
