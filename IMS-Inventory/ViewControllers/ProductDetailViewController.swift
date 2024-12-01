import UIKit

class ProductDetailViewController: UIViewController {
    
    // MARK: - UI Components
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = UIColor.systemGray6
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
    
    private let sendBtn: ConfirmButton = {
        let btn = ConfirmButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Properties
    private enum Section: Int, CaseIterable {
        case image
        case basicInfo
        case details
        case quantity
    }
    
    private var selectedDate: Date?
    private var selectedStatus: String?
    private var quantity: Int = 1
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        addTargets()
    }
    
    // MARK: - Setup
    private func setupUI() {
        setNavigationView()
        self.view.backgroundColor = UIColor.systemGray6
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
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductImageCell.self, forCellReuseIdentifier: "ProductImageCell")
        tableView.register(ProductInfoCell.self, forCellReuseIdentifier: "ProductInfoCell")
        tableView.register(ProductQuantityCell.self, forCellReuseIdentifier: "ProductQuantityCell")
    }
    
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
        let customTitleView = CustomNavigationTitleView(title: Constants.nav_title_list)
        navigationItem.titleView = customTitleView
        
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    // MARK: - Actions
    func addTargets() {
        sendBtn.addTarget(self, action: #selector(confirmBtnTapped), for: .touchUpInside)
    }
    
    @objc private func confirmBtnTapped(_ sender: UIButton) {
        let shoppingCartVC = CartViewController()
        shoppingCartVC.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(shoppingCartVC, animated: true)
    }
    
    @objc private func stepperValueChanged(_ stepper: UIStepper) {
        quantity = Int(stepper.value)
        tableView.reloadSections(IndexSet(integer: Section.quantity.rawValue), with: .none)
    }
}

// MARK: - UITableViewDataSource
extension ProductDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .image:
            return 1
        case .basicInfo:
            return 1
        case .details:
            return 2  // 日期和狀態
        case .quantity:
            return 2  // 庫存和數量選擇
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductImageCell", for: indexPath) as! ProductImageCell
            cell.configure(with: productImageView.image)
            return cell
            
        case .basicInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductInfoCell", for: indexPath) as! ProductInfoCell
            cell.configure(articleNumber: "No.10150")
            return cell
            
        case .details:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "使用日期"
                cell.detailTextLabel?.text = "請選擇日期"
            case 1:
                cell.textLabel?.text = "狀態選擇"
                cell.detailTextLabel?.text = "請選擇狀態"
            default:
                break
            }
            cell.accessoryType = .disclosureIndicator
            return cell
            
        case .quantity:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductQuantityCell", for: indexPath) as! ProductQuantityCell
            if indexPath.row == 0 {
                cell.configure(title: "庫存數:", value: "100")
            } else {
                cell.configureWithStepper(title: "數量:", value: quantity) { [weak self] stepper in
                    self?.stepperValueChanged(stepper)
                }
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension ProductDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else { return UITableView.automaticDimension }
        switch section {
        case .image:
            return 250
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch section {
        case .details:
            // Handle date and status selection
            if indexPath.row == 0 {
                // Show date picker
                print("Show date picker")
            } else {
                // Show status picker
                print("Show status picker")
            }
        default:
            break
        }
    }
}

#Preview {
    UINavigationController(rootViewController: ProductDetailViewController())
}
