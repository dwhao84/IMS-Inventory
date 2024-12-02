import UIKit

class ProductDetailViewController: UIViewController {
    
    var qtyValue: Int = 0
    
    // MARK: - UI Components
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
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
        view.backgroundColor = Colors.white
        self.view.addSubview(tableView)
        self.view.addSubview(sendBtn)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
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
        tableView.backgroundColor = Colors.white
        tableView.register(ProductImageCell.self, forCellReuseIdentifier: ProductImageCell.identifier)
        tableView.register(ProductInfoCell.self, forCellReuseIdentifier: ProductInfoCell.identifier)
        tableView.register(ProductQuantityCell.self, forCellReuseIdentifier: ProductQuantityCell.identifier)
        tableView.register(DateTableViewCell.self, forCellReuseIdentifier: DateTableViewCell.identifier)
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
        let customTitleView = CustomNavigationTitleView(title: Constants.nav_title_detail)
        navigationItem.titleView = customTitleView
        
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    // MARK: - Actions
    func addTargets() {
        sendBtn.addTarget(self, action: #selector(confirmBtnTapped), for: .touchUpInside)
    }
    
    @objc func confirmBtnTapped(_ sender: UIButton) {
        let shoppingCartVC = CartViewController()
        shoppingCartVC.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(shoppingCartVC, animated: true)
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
            return 4  // 因為你有 ProductImageCell, ProductInfoCell, 和 ProductQuantityCell 三種
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductImageCell.identifier, for: indexPath) as! ProductImageCell
            cell.configure(with: Images.photoLibrary)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductInfoCell.identifier, for: indexPath) as! ProductInfoCell
            cell.configure(articleNumber: "15525", rackingText: "BASKET F MULTIUSE W300 D800MM GALV", qtyText: "Qty: 10")
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductQuantityCell.identifier, for: indexPath) as! ProductQuantityCell
            cell.configureWithStepper(title: "Require Qty", value: qtyValue) { [weak self] stepper in
                self?.qtyValue = Int(stepper.value)
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            }
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: DateTableViewCell.identifier, for: indexPath) as! DateTableViewCell
            cell.configure(title: "Using Date")
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
            return 150
        case 2:
            return 90
        case 3:
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
