import UIKit

class SettingViewController: UIViewController {
    
    // MARK: - Properties
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 60
        return tableView
    }()
    
    private var sections: [SettingsSection] = [
        SettingsSection(items: [
            Service(
                image: Images.bookPages,
                title: "免責聲明",
                url: "https://dwhao84.blogspot.com/2024/07/blog-post.html?m=1",
                color: .systemRed
            ),
            Service(
                image: Images.gear,
                title: "版本 V 1.1.0",
                url: "",
                color: .blue
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
        view.backgroundColor = .systemBackground
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Setup delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register cell
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = Colors.darkGray
        titleLabel.text = "設定"
        titleLabel.minimumScaleFactor = 0.3
        titleLabel.adjustsFontSizeToFitWidth = true
        navigationItem.titleView = titleLabel
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = true
    }
}

// MARK: - UITableView DataSource & Delegate
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
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
        
        // Configure content
        content.text = service.title
        content.image = service.image
        content.imageProperties.tintColor = service.color
        content.textProperties.color = Colors.darkGray
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let service = sections[indexPath.section].items[indexPath.row]
        if !service.url.isEmpty, let url = URL(string: service.url) {
            UIApplication.shared.open(url)
        }
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

