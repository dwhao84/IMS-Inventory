import UIKit
import Kingfisher

// MARK: - CartViewController
class CartViewController: UIViewController {
    
    var borrowReturnRecords: [BorrowReturn.Record] = []
    
    // MARK: - Types
    private enum Layout {
        static let rowHeight: CGFloat = 175.0
    }
    
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = Colors.white
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = Colors.black
        control.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return control
    }()
    
    private lazy var refreshButton: UIButton = {
        let btn = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Colors.black
        config.image = Images.arrowClockwise
        config.cornerStyle = .capsule
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.configurationUpdateHandler = { btn in
            btn.alpha = btn.isHighlighted ? 0.5 : 1
            btn.configuration = config
        }
        return btn
    }()
    
    let searchController: UISearchController = {
        let searchController = UISearchController()
        
        return searchController
    } ()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Into the CartViewController")
        
        setupUI()
        fetchData()
    }
    
    // MARK: - view Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.viewControllers?[1].tabBarItem.badgeValue = nil
    }
    
    // MARK: - did Receive Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning")
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.overrideUserInterfaceStyle = .light
        view.backgroundColor = Colors.white
        
        configureTableView()
        configureNavigationBar()
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    }
    
    func fetchData() {
        NetworkManager.shared.getBorrowReturnData { [weak self] result in
            switch result {
            case .success(let records):
                DispatchQueue.main.async {
                    self?.borrowReturnRecords = records
                    self?.tableView.reloadData()  // 需要加入這行
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error fetching data: \(error)")
                }
            }
        }
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: Colors.darkGray
        ]
        navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.searchController = searchController
        navigationItem.titleView = CustomNavigationTitleView(title: (String(localized: "Cart")))
        let rightBarButtonItem = UIBarButtonItem(customView: refreshButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    
    @objc private func refreshButtonTapped(_ sender: UIButton) {
        print("=== refreshButtonTapped ===")
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = Double.pi * 2 // Full rotation (360 degrees)
        rotateAnimation.duration = 0.5
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        refreshButton.layer.add(rotateAnimation, forKey: nil)
    }
    
    // MARK: - Actions
    @objc private func handleRefresh() {
        print("== API Call again ===")
        // Implement refresh logic here
        refreshControl.endRefreshing()
        fetchData()
    }
    
}

// MARK: - UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    // MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updateTableViewBackground(tableView, isEmpty: borrowReturnRecords.isEmpty)
        return borrowReturnRecords.count
    }
    
    // MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CartTableViewCell.identifier,
            for: indexPath
        ) as! CartTableViewCell
        
        let fields = borrowReturnRecords[indexPath.row].fields
        cell.articleNumberLabel.text = fields.articleNumber ?? String(localized: "N/A")
        cell.productENNameLabel.text = fields.rackingDescription ?? String(localized: "N/A")
        cell.orderNumberLabel.text = fields.orderNumber ?? String(localized: "N/A")
        cell.dateLabel.text = fields.createdDate ?? String(localized: "N/A")
        cell.statusLabel.text = fields.status ?? String(localized: "N/A")
        cell.userNameLabel.text = fields.user_name ?? String(localized: "N/A")  // 添加預設值
        cell.dateLabel.text = fields.createdDate
        cell.qtyLabel.text = "Qty: \(fields.rackingQty ?? 0)"
        
        if let imageUrl = fields.imageUrl,
           let url = URL(string: imageUrl) {
            cell.productImageView.kf.setImage(with: url)
        } else {
            cell.productImageView.image = nil
        }
        return cell
    }
    
    /// 設定 TableView 的滑動刪除動作
    // MARK: - trailingSwipeActionsConfigurationForRowAt
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       // 建立刪除動作按鈕
       let deleteAction = UIContextualAction(style: .destructive, title: Constants.delete) { [weak self] (action, view, completionHandler) in
           // 檢查 self 是否存在，避免記憶體洩漏
           guard let self = self else {
               completionHandler(false)
               return
           }
           
           // 從資料陣列中獲取要刪除記錄的 ID
           let recordId = self.borrowReturnRecords[indexPath.row].id
           // 建立包含特定記錄 ID 的完整 URL
           let deleteUrl = API.baseUrl.appendingPathComponent(recordId)
           
           // 設定 HTTP 請求
           var request = URLRequest(url: deleteUrl)
           request.httpMethod = "DELETE"
           request.setValue("Bearer \(API.apiKey)", forHTTPHeaderField: "Authorization")
           
           // 發送網路請求
           URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
               // 在主線程處理回應
               DispatchQueue.main.async {
                   // 檢查 HTTP 回應狀態碼
                   if let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 {
                       
                       // 刪除成功：更新本地資料和 UI
                       self?.borrowReturnRecords.remove(at: indexPath.row)
                       tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
                       completionHandler(true)
                   } else {
                       guard let self = self else {
                           completionHandler(false)
                           return
                       }
                       AlertManager.showButtonAlert(on: self,
                                                 title: Constants.error,
                                                 message: Constants.deleteFailed)
                       completionHandler(false)
                   }
               }
           }.resume()
       }
       // 設定刪除按鈕的背景顏色
       deleteAction.backgroundColor = .red
       
       // 建立並返回滑動動作配置
       let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
       return configuration
    }
}

// MARK: - setupEmptyTableViewBackground
extension UIViewController {
    func setupEmptyTableViewBackground(_ tableView: UITableView) {
        // 建立一個容器視圖
        let containerView = UIView()
        // 建立圖片視圖
        let imageView = UIImageView()
        imageView.image = Images.folderBadgePlus
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Colors.darkGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // 創建標籤
        let label = UILabel()
        label.text = String(localized: "No Data")
        label.textAlignment = .center
        label.textColor = Colors.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // 將圖片視圖和標籤添加到容器中
        containerView.addSubview(imageView)
        containerView.addSubview(label)
        
        // 設置約束
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -30),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
        
        tableView.backgroundView = containerView
    }
    
    func updateTableViewBackground(_ tableView: UITableView, isEmpty: Bool) {
        if isEmpty {
            setupEmptyTableViewBackground(tableView)
        } else {
            tableView.backgroundView = nil
        }
    }
}
        
// MARK: - SwiftUI Preview
#Preview {
    UINavigationController(rootViewController: CartViewController())
}
