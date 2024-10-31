import UIKit

class SettingViewController: UIViewController {
    
    let largeTitle: String = "Settings"
    
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
        setupTableView()
        setNavigationView()
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 設置 contentInset
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
    }
    
    func setNavigationView() {
        // 設置基本屬性
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = largeTitle
        
        // 創建並配置 NavigationBar 外觀
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 使用不透明背景
        
        // 設置背景顏色
        appearance.backgroundColor = .systemBackground
        
        // 設置標題顏色
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        // 重要：同時設置這三種外觀狀態
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // 確保即時更新外觀
        navigationController?.navigationBar.tintColor = .label
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

