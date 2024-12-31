import UIKit
import Kingfisher
import UIView_Shimmer

class ProductListViewController: UIViewController {
    private var records: [Record] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var filteredRecords: [Record] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - TableView
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = Colors.white
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = Colors.black
        return refreshControl
    }()
    
    // MARK: - SearchController
    let searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchBar.sizeToFit()
        controller.automaticallyShowsCancelButton = true
        controller.searchBar.placeholder = String(localized: "Item, Article No, Description")
        controller.isActive = true
        controller.searchBar.searchTextField.returnKeyType = .search
        controller.hidesNavigationBarDuringPresentation = false
        controller.obscuresBackgroundDuringPresentation = true
        return controller
    }()
    
    lazy var filterBtn: UIButton = {
        let btn = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Colors.black
        config.image = Images.line_3_horizontal_decrease
        config.cornerStyle = .capsule
        btn.configuration = config
        btn.addTarget(self, action: #selector(filterBtnTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.configurationUpdateHandler = { btn in
            btn.alpha = btn.isHighlighted ? 0.5 : 1
            btn.configuration = config
        }
        return btn
    } ()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Into the ProductListViewController")
        view.overrideUserInterfaceStyle = .light
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
        setupUI()
        tableView.refreshControl = refreshControl
        fetchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning")
    }
    
    func setupUI() {
        setNavigationView()
        addSearchControllerDelegates()
        addTargets()
        addDelegateAndDataSource()
        addConstraints()
    }
    
    func setNavigationView() {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithDefaultBackground()
        self.navigationController?.navigationBar.standardAppearance = standardAppearance
        
        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.configureWithDefaultBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance = scrollAppearance
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.darkGray]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        // 使用客製化的標題視圖
        let customTitleView = CustomNavigationTitleView(title: String(localized: "List"))
        navigationItem.titleView = customTitleView
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.searchController = searchController
        
        // 將 UIButton 轉換為 UIBarButtonItem
        let rightBarButton = UIBarButtonItem(customView: filterBtn)
        // 設置到導航欄
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func addTargets() {
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
    }
    
    func addDelegateAndDataSource() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
        tableView.refreshControl = refreshControl
    }
    
    func addConstraints() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func addSearchControllerDelegates() {
        searchController.searchBar.delegate = self
    }
    
    @objc func refreshControlValueChanged(_ sender: Any) {
        print("refresh Control Value Changed")
        fetchData()
        refreshControl.endRefreshing()
    }
    
    @objc func filterBtnTapped(_ sender: UIButton) {
        filterBtn.showsMenuAsPrimaryAction = true
        filterBtn.menu = UIMenu(children: [
            // 貨號排序
            UIAction(title: String(localized: "Article No: Ascending"), image: Images.arrowUp, handler: { [weak self] _ in
                guard let self = self else { return }
                // 直接設定 records
                self.records = self.records.sorted { (record1: Record, record2: Record) in
                    return record1.fields.articleNumber.compare(record2.fields.articleNumber,
                                                                options: .numeric) == .orderedAscending
                }
            }),
            
            UIAction(title: String(localized: "Article No: Descending"), image: Images.arrowDown, handler: { [weak self] _ in
                guard let self = self else { return }
                self.records = self.records.sorted { (record1: Record, record2: Record) in
                    return record1.fields.articleNumber.compare(record2.fields.articleNumber,
                                                                options: .numeric) == .orderedDescending
                }
            }),
            
            // 名稱排序
            UIAction(title: String(localized: "Name: A to Z"), image: Images.textFormatAbc, handler: { [weak self] _ in
                guard let self = self else { return }
                self.records = self.records.sorted { $0.fields.articleName < $1.fields.articleName }
            }),
            
            // 數量排序
            UIAction(title: String(localized: "Quantity: High to Low"), image: Images.number, handler: { [weak self] _ in
                guard let self = self else { return }
                self.records = self.records.sorted { $0.fields.Qty > $1.fields.Qty }
            })
        ])
    }
    
    private func fetchData() {
        activityIndicator.startAnimating()
        NetworkManager.shared.getProductData { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                switch result {
                case .success(let records):
                    self.records = records
                    self.filteredRecords = records
                case .failure(let error):
                    print("Error fetching data: \(error)")
                }
            }
        }
    }
    
    private func performSearch(with searchText: String) {
        guard !searchText.isEmpty else {
            filteredRecords = records
            return
        }
        
        filteredRecords = records.filter { record in
            record.fields.articleName.lowercased().contains(searchText.lowercased()) ||
            record.fields.articleNumber.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredRecords.count : records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as! ProductTableViewCell
        
        let record = searchController.isActive ? filteredRecords[indexPath.row] : records[indexPath.row]
        cell.articleNumberLabel.text = record.fields.articleNumber
        cell.productENNameLabel.text = record.fields.articleName
        cell.productENNameLabel.text = record.fields.articleName
        cell.qtyLabel.text = String(localized:"Stock Qty: \(record.fields.Qty)")
        
        if let imageUrlString = record.fields.image.last?.url,
           let url = URL(string: imageUrlString) {
            cell.productImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "photo.fill"),
                options: [.transition(.fade(0.2)), .cacheOriginalImage]
            )
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedRecord = searchController.isActive ? filteredRecords[indexPath.row] : records[indexPath.row]
        
        let productDetailVC = ProductDetailViewController()
        productDetailVC.imageUrl = selectedRecord.fields.image.last?.url
        productDetailVC.productTitle = selectedRecord.fields.articleName
        productDetailVC.articleNumber = selectedRecord.fields.articleNumber
        productDetailVC.qty = "Qty: \(selectedRecord.fields.Qty) pcs"
        
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension ProductListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch(with: searchText)
        print("searchBar textDidChange")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredRecords = records
        tableView.reloadData()
        print("searchBar Cancel Button Clicked")
    }
}

// MARK: - Preview
#Preview {
    UINavigationController(rootViewController: ProductListViewController())
}
