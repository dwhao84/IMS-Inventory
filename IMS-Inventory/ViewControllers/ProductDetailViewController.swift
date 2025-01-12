import UIKit
import FirebaseAnalytics

class ProductDetailViewController: UIViewController {
    private var nameCell: NameFillCell?
    
    var qtyValue: Int = 1
    private var selectedDate: Date?
    private var selectedStatus: String = String(localized:"Return") // 設置一個初始值
    private var quantity: Int = 1
    
    var imageUrl: String?
    var productTitle: String?
    var articleNumber: String?
    var qty: String?
    
    // MARK: - UI Components
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = UIColor.systemGray6
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.photoLibrary
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.tintColor = Colors.black
        imageView.layer.borderWidth = 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let sendBtn: SendButton = {
        let btn = SendButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Into the ProductDetailViewController")
        
        setupUI()
        setupTableView()
        addTargets()
    }
    
    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        // Debug print to verify data is received
        print("ViewDidAppear - Current Values:")
        print("imageUrl: \(String(describing: imageUrl))")
        print("articleNumber: \(String(describing: articleNumber))")
        print("productTitle: \(String(describing: productTitle))")
        print("qty: \(String(describing: qty))")
    }
    
    // MARK: - did Receive Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("=== didReceiveMemoryWarning ===")
    }
    
    // MARK: - Setup
    private func setupUI() {
        setNavigationView()
        view.backgroundColor = Colors.white
        self.view.addSubview(tableView)
        self.view.addSubview(sendBtn)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: sendBtn.topAnchor, constant: -20),
            
            sendBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            sendBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            sendBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            sendBtn.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    // MARK: - Set up TableView
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Colors.white
        tableView.register(ProductImageCell.self, forCellReuseIdentifier: ProductImageCell.identifier)
        tableView.register(ProductInfoCell.self, forCellReuseIdentifier: ProductInfoCell.identifier)
        tableView.register(ProductQuantityCell.self, forCellReuseIdentifier: ProductQuantityCell.identifier)
        tableView.register(DateTableViewCell.self, forCellReuseIdentifier: DateTableViewCell.identifier)
        tableView.register(StatusCell.self, forCellReuseIdentifier: StatusCell.identifier)
        tableView.register(NameFillCell.self, forCellReuseIdentifier: NameFillCell.identifier)
    }
    
    // MARK: - Set up NavigationView
    private func setNavigationView() {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithDefaultBackground()
        self.navigationController?.navigationBar.standardAppearance = standardAppearance
        
        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.configureWithDefaultBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance = scrollAppearance
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.darkGray]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        // 使用客製化的標題視圖
        let customTitleView = CustomNavigationTitleView(title: productTitle!)
        navigationItem.titleView = customTitleView
        
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    // MARK: - Testing for make sure the data is passing or not.
    func configure(with record: Record) {
        self.imageUrl = record.fields.image.last?.url
        self.productTitle = record.fields.articleName
        self.articleNumber = record.fields.articleNumber
        self.qty = String(localized:"Qty: \(record.fields.Qty) pcs")
        
        // If the view is already loaded, reload the table
        if isViewLoaded {
            tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    func addTargets() {
        sendBtn.addTarget(self, action: #selector(sendBtnTapped), for: .touchUpInside)
    }
    
    private func validateInput() -> (isValid: Bool, errorMessage: String?) {
        // 檢查用戶名
        guard let nameTextField = view.findSubview(ofType: NameFillCell.self)?.nameTextField,
              !nameTextField.text!.isEmpty else {
            return (false, String(localized: "Missing User Name."))
        }
        
        // 檢查產品資訊
        guard articleNumber != nil else {
            return (false, String(localized: "Article number is missing."))
        }
        
        guard productTitle != nil else {
            return (false, String(localized: "Product title is missing."))
        }
        
        return (true, nil)
    }
    
    // MARK: - Loading Indicator
    private func showLoading() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: String(localized:"Processing..."), preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        alert.view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor)
        ])
        
        indicator.startAnimating()
        return alert
    }
    
    // MARK: - Actions
    @objc func sendBtnTapped(_ sender: UIButton) {
        // Add Analytics
        Analytics.logEvent("ProductDetailVC SendBtn", parameters: nil)
        
        shakeSendButton()
        // 驗證輸入
        let validation = validateInput()
        guard validation.isValid else {
            AlertManager.showButtonAlert(
                on: self,
                title: String(localized: "Error"),
                message: validation.errorMessage ?? ""
            )
            return
        }
        
        // 獲取必要資料
        let userName = view.findSubview(ofType: NameFillCell.self)?.nameTextField.text ?? ""
        let status = selectedStatus 
        
        // 顯示加載指示器
        let loadingAlert = showLoading()
        present(loadingAlert, animated: true)
        
        // 發送請求
        NetworkManager.shared.createBorrowReturn(
            articleNumber: articleNumber!,
            rackingDescription: productTitle!,
            orderNumber: UUID().uuidString,
            status: status,
            rackingQty: qtyValue,
            userName: userName,
            imageUrl: imageUrl!
        ) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                loadingAlert.dismiss(animated: true) {
                    switch result {
                    case .success:
                        
                        print("=== Sending notification ===")
                        NotificationCenter.default.post(name: .didAddNewItem, object: nil)
                        
                        print("=== Add ITEM Success ===")
                        
                    case .failure(let error):
                        AlertManager.showButtonAlert(
                            on: self,
                            title: String(localized: "Error"),
                            message: error.localizedDescription
                        )
                    }
                }
            }
        }
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }
}

// MARK: - UITableViewDataSource
extension ProductDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6  // 因為有 ProductImageCell, ProductInfoCell, 和 ProductQuantityCell 三種
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductImageCell.identifier, for: indexPath) as! ProductImageCell
            if let imageUrl = imageUrl,
               let url = URL(string: imageUrl) {
                cell.productImageView.kf.setImage(
                    with: url,
                    placeholder: Images.photoLibrary,
                    options: [.transition(.fade(0.2)), .cacheOriginalImage]
                )
            }
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductInfoCell.identifier, for: indexPath) as! ProductInfoCell
            cell.configure(
                articleNumber: articleNumber ?? "",
                rackingText: productTitle ?? "",
                qtyText: qty ?? "Qty: 0 pcs"
            )
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: NameFillCell.identifier, for: indexPath) as! NameFillCell
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: DateTableViewCell.identifier, for: indexPath) as! DateTableViewCell
            cell.configure(title: String(localized: "Using Date"))
            cell.datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
            if let selectedDate = selectedDate {
                cell.datePicker.date = selectedDate
            }
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: StatusCell.identifier, for: indexPath) as! StatusCell
            cell.updateSelectedStatus(selectedStatus)
            
            // 添加狀態改變的監聽
            cell.statusChanged = { [weak self] newStatus in
                self?.selectedStatus = newStatus
            }
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductQuantityCell.identifier, for: indexPath) as! ProductQuantityCell
            cell.configureWithStepper(title: String(localized:"Require Qty"), value: qtyValue) { [weak self] stepper in
                self?.qtyValue = Int(stepper.value)
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}


// MARK: - UITableViewDelegate
extension ProductDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 260
        case 1:
            return UITableView.automaticDimension
        case 2:
            return 150
        case 3:
            return 150
        case 4, 5:
            return 90
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("indexPath:\(indexPath.row)")
    }
}


#Preview {
    UINavigationController(rootViewController: ProductDetailViewController())
}

extension UIView {
    func findSubview<T: UIView>(ofType type: T.Type) -> T? {
        return subviews.compactMap { $0 as? T ?? $0.findSubview(ofType: type) }.first
    }
}

extension ProductDetailViewController {
    func shakeSendButton() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        sendBtn.layer.add(animation, forKey: "shake")
    }
}
