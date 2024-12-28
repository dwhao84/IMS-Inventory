import UIKit
import MessageUI


class SettingViewController: UIViewController {
    
    let navigationItemTitle: String = String(localized: "Settings")
    
    // MARK: - Properties
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 60
        return tableView
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "Version V 1.1.0")
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sections: [SettingsSection] = [
        SettingsSection(items: [
            Service(
                image: Images.bookPages,
                title: String(localized: "Disclaimer"),
                url: "https://dwhao84.blogspot.com/2024/07/blog-post.html?m=1",
                color: .systemRed
            ),
            Service(
                image: Images.mail,
                title: String(localized: "Problem Report"),
                url: "",
                color: Colors.black
            )
        ])
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.systemGray6
        setupTableView()
        setNavigationView()
    }
    
    private func setupTableView() {
        // 確保 Auto Layout 正確運作
        tableView.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.translatesAutoresizingMaskIntoConstraints = false

        // 添加 subviews
        self.view.addSubview(versionLabel)
        self.view.addSubview(tableView)
        
        // 設定 constraints
        NSLayoutConstraint.activate([
            // TableView constraints
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 180),
            // VersionLabel constraints
            versionLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor), // 直接連接到 tableView 的底部
            versionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            versionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            versionLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10) // 添加 8 點的間距
        ])
        
        // 設定 TableView 相關配置
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
    }
    
    func setNavigationView() {
        let standardAppearance = UINavigationBarAppearance()
        self.navigationController?.navigationBar.standardAppearance = standardAppearance
        
        let scrollAppearance = UINavigationBarAppearance()
        self.navigationController?.navigationBar.scrollEdgeAppearance = scrollAppearance
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.darkGray]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.navigationItem.title = navigationItemTitle
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["dwhao84@gmail.com"])
            mail.setMessageBody("<p>Hi there, there have some problem</p>", isHTML: true)
            present(mail, animated: true)
        } else {
            // show failure alert
            print("=== Unable to send e-mail. ===")
        }
    }
}

// MARK: - UITableView DataSource & Delegate
extension SettingViewController: UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        
        let service = sections[indexPath.section].items[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = service.title
        content.image = service.image
        content.imageProperties.tintColor = service.color
        // 使用 label 顏色而不是固定的深灰色
        content.textProperties.color = .label
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let service = sections[indexPath.section].items[indexPath.row]
        if service.title == Constants.report {
            sendEmail()
        } else if !service.url.isEmpty, let url = URL(string: service.url) {
            UIApplication.shared.open(url)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
            // Handle the mail composition result if needed
        }
}

// MARK: - Models
struct SettingsSection {
    let items: [Service]
}

struct Service {
    let image: UIImage
    let title: String
    let url: String
    let color: UIColor
}

#Preview {
    UINavigationController(rootViewController: SettingViewController())
}

