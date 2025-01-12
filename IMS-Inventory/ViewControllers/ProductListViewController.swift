import UIKit
import Kingfisher
import UIView_Shimmer

class ProductListViewController: UIViewController {
    
    private let viewModel = ProductListViewModel()
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
        setupBindings()
        setupUI()
        setupActivityIndicator()
        tableView.refreshControl = refreshControl
        fetchData()
    }
    
    // MARK: - did Receive Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning")
    }
    
    // MARK: - setup Bindings
    private func setupBindings() {
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { error in
            DispatchQueue.main.async {
                // 這裡可以添加錯誤提示UI
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func setupUI() {
        setNavigationView()
        addTargets()
        setupSearchController()
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
    
    fileprivate func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
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
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self // 如果要即時搜尋的話
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @objc func refreshControlValueChanged(_ sender: Any) {
        viewModel.refreshData { [weak self] error in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc func filterBtnTapped(_ sender: UIButton) {
        filterBtn.showsMenuAsPrimaryAction = true
        filterBtn.menu = UIMenu(children: [
            UIAction(
                title: String(localized: "Article No: Ascending"),
                image: Images.arrowUp,
                handler: { [weak self] _ in
                    self?.viewModel.sortRecords(by: .articleNumberAscending)
                }
            ),
            UIAction(
                title: String(localized: "Article No: Descending"),
                image: Images.arrowDown,
                handler: { [weak self] _ in
                    self?.viewModel.sortRecords(by: .articleNumberDescending)
                }
            ),
            UIAction(
                title: String(localized: "Name: A to Z"),
                image: Images.textFormatAbc,
                handler: { [weak self] _ in
                    self?.viewModel.sortRecords(by: .nameAToZ)
                }
            ),
            UIAction(
                title: String(localized: "Quantity: High to Low"),
                image: Images.number,
                handler: { [weak self] _ in
                    self?.viewModel.sortRecords(by: .quantityHighToLow)
                }
            )
        ])
    }
    
    private func fetchData(isInitialLoad: Bool = true) {
        viewModel.fetchData(isInitialLoad: isInitialLoad) { error in
            if let error = error {
                print("Error fetching data: \(error)")
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as! ProductTableViewCell
        let cellViewModel = viewModel.cellViewModel(at: indexPath.row)
        
        cell.articleNumberLabel.text = cellViewModel.articleNumber
        cell.productENNameLabel.text = cellViewModel.articleName
        cell.qtyLabel.text = cellViewModel.stockQuantity
        
        if let imageUrl = cellViewModel.imageUrl {
            cell.productImageView.kf.setImage(
                with: imageUrl,
                placeholder: Images.photoLibrary,
                options: [
                    .transition(
                        .fade(
                            0.2
                        )
                    ),
                    .cacheOriginalImage
                ]
            )
        }
        
        viewModel.loadMoreIfNeeded(at: indexPath.row) { [weak self] error in
              if let error = error {
                  print("Error loading more data: \(error)")
                  return
              }
              DispatchQueue.main.async {
                  self?.tableView.reloadData()
              }
          }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.backgroundColor = Colors.lightGray
        
        print(viewModel.debugInfo(for: indexPath.row))
        
        let detailViewModel = viewModel.detailViewModel(at: indexPath.row)
        
        let productDetalVC = ProductDetailViewController()
        productDetalVC.imageUrl = detailViewModel.imageUrl
        productDetalVC.productTitle = detailViewModel.productTitle
        productDetalVC.articleNumber = detailViewModel.articleNumber
        productDetalVC.qty = detailViewModel.quantityText
        
        self.navigationController?.pushViewController(productDetalVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension ProductListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.isSearching = !searchText.isEmpty
        viewModel.filterContent(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        viewModel.isSearching = !searchText.isEmpty
        viewModel.filterContent(with: searchText)
        searchBar.resignFirstResponder() // 收起鍵盤
    }
}

extension ProductListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.isSearching = !searchText.isEmpty
        viewModel.filterContent(with: searchText)
    }
}

// MARK: - Preview
#Preview {
    UINavigationController(rootViewController: ProductListViewController())
}
