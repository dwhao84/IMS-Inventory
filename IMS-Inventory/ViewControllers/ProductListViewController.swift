//
//  ItemTableViewController.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2023/11/9.
//

import UIKit
import Kingfisher
import UIView_Shimmer

class ProductListViewController: UIViewController {
    private var productData: Product?
    lazy var filteredRecords:[Record] = []
    
    // MARK: - Checking Networking:
    enum NetworkError: Error {
        case invalidURL
        case requestFailed
        case decodingError
    }
    
    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - CollectionView:
    let collectionView: UICollectionView = {
        let itemSpace:   CGFloat = 1
        let columnCount: CGFloat = 1
        // 計算每個 item 的寬度，確保圖片適配不同設備
        let width = floor((UIScreen.main.bounds.width - itemSpace * (columnCount - 1)) / columnCount)

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: width, height: width * 1.4)
        flowLayout.estimatedItemSize = .zero
        flowLayout.minimumLineSpacing = itemSpace
        flowLayout.minimumInteritemSpacing = itemSpace
        
        flowLayout.collectionView?.layer.cornerRadius = 20
        flowLayout.collectionView?.clipsToBounds = true
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = Colors.white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let refreshControl: UIRefreshControl = {
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.tintColor = Colors.IKEA_Blue
        return refreshControl
    } ()

    // MARK: - SearchController:
    let searchController: UISearchController = {
        let controller: UISearchController = UISearchController()
        controller.searchBar.sizeToFit()
        controller.automaticallyShowsCancelButton = true
        controller.searchBar.placeholder = "Item, Article No, Description"
        controller.isActive = true
        controller.searchBar.searchTextField.returnKeyType = .search
        controller.hidesNavigationBarDuringPresentation = false
        controller.obscuresBackgroundDuringPresentation = true         // 新增當點選searchBar時，背景會產生半透明的效果。
        return controller
    } ()
    
    // MARK: - Life Cycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.white
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
        setupUI()
        fetchData()
        
        collectionView.refreshControl = refreshControl
    }
    
    // MARK: - Sent to the view controller when the app receives a memory warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("didReceiveMemoryWarning")
    }
    
    func setupUI() {
        setNavigationView()
        addSearchControllerDelegates()
        addTargets()
        addDelegateAndDataSource()
        addConstraints()
        
        filteredRecords = productData?.records ?? []
    }
    
    func setNavigationView () {
        let standardAppearance = UINavigationBarAppearance()
        self.navigationController?.navigationBar.standardAppearance = standardAppearance
        
        let scrollAppearance = UINavigationBarAppearance()
        self.navigationController?.navigationBar.scrollEdgeAppearance = scrollAppearance

        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.darkGray]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.navigationItem.title = "IMS Stock Qty"
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = searchController
    }
    
    func addTargets() {
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
    }
    
    func addDelegateAndDataSource() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            ProductCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductCollectionViewCell.identifier
        )
        collectionView.allowsSelection = true
        collectionView.refreshControl = refreshControl
    }
    
    func addConstraints() {
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func addSearchControllerDelegates () {
        searchController.searchBar.delegate = self
    }
    
    func fetchData () {
        guard let url = URL(string: API.baseUrl) else {
            return
        }
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
              
        var request = URLRequest(url: url)
        request.setValue("Bearer \(API.apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                 self.activityIndicator.stopAnimating()
                 self.view.isUserInteractionEnabled = true // 恢復用戶交互
             }
            
            if let error = error {
                print("DEBUG PRINT: Request error: \(error.localizedDescription)")
                return
            }
            guard let data = data else { print("DEBUG PRINT: No data received"); return }
            
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Product.self, from: data)
                DispatchQueue.main.async { [self] in
                    self.productData = jsonData
                    self.collectionView.reloadData()  // Ensure UI updates happen on the main thread
                    print("Fetch Data already")
                    print(jsonData)
                }
            } catch {
                print("Decode error: \(error.localizedDescription)")
                if let rawJSONString = String(data: data, encoding: .utf8) {
                    print("DEBUG PRINT: Received JSON - \(rawJSONString)")
                }
            }
        }.resume()
    }
    
    @objc func refreshControlValueChanged (_ sender: Any) {
        refreshControl.endRefreshing()
        print("refreshControlValueChanged")
    }
    
    private func performSearch(with searchText: String) {
         guard let records = productData?.records else { return }
         
         filteredRecords = records.filter { record in
             record.fields.articleName.lowercased().contains(searchText.lowercased()) ||
             record.fields.articleNameInChinese.contains(searchText) ||
             record.fields.articleNumber.lowercased().contains(searchText.lowercased())
         }
         
         collectionView.reloadData()
     }
    
    // MARK: - Handle device rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            let itemSpace: CGFloat = 1
            let columnCount: CGFloat = 1
            let width = floor((size.width - itemSpace * (columnCount - 1)) / columnCount)
            if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.itemSize = CGSize(width: width, height: width)
                self.collectionView.collectionViewLayout.invalidateLayout()
            }
        }, completion: nil)
    }
}

extension ProductListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredRecords.count
        } else {
            return productData?.records.count ?? 0
        }
    }
    
    // MARK: - cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
        
        // 取得正確的資料來源
        let product = (searchController.isActive) ? filteredRecords[indexPath.row] : productData?.records[indexPath.row]
        
        // 設定文字
        cell.articleNumberLabel.text = product?.fields.articleNumber ?? "Loading..."
        cell.productTCNameLabel.text = product?.fields.articleNameInChinese ?? "Loading..."
        cell.productENNameLabel.text = product?.fields.articleName ?? "Loading..."
        
        // 設定圖片
        if let imageUrlString = product?.fields.image.last?.url,
           let url = URL(string: imageUrlString) {
            cell.productImageView.kf.setImage(
                with: url,
                placeholder: Images.image, // 載入中顯示的預設圖片
                options: [
                    .transition(.fade(0.2)), // 淡入淡出效果
                    .cacheOriginalImage // 快取原始圖片
                ])
        } else {
            cell.productImageView.image = Images.image
        }
        
        return cell
    }
    
    // MARK: - didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        
        let productDetailVC = ProductDetailViewController()
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    // MARK: - sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpace: CGFloat = 1
        let columnCount: CGFloat = 1
        let width = floor((collectionView.bounds.width - itemSpace * (columnCount - 1)) / columnCount)
        
        // 假設最小高度為圖片高度加上一些額外空間
        let minHeight: CGFloat = 170 // 150 (圖片高度) + 20 (上下間距)
        
        // 計算文字內容的高度
        let product = productData?.records[indexPath.row]
        let tcNameHeight = heightForLabel(text: product?.fields.articleNameInChinese ?? "", font: ProductCollectionViewCell.scriptFont(size: 15), width: width - 190)
        let enNameHeight = heightForLabel(text: product?.fields.articleName ?? "", font: ProductCollectionViewCell.scriptFont(size: 13), width: width - 190)
        let articleNumberHeight = heightForLabel(text: product?.fields.articleNumber ?? "", font: ProductCollectionViewCell.scriptFont(size: 15), width: width - 190)
        
        // 計算總高度
        let totalHeight = max(minHeight, tcNameHeight + enNameHeight + articleNumberHeight + 60) // 60 為額外間距
        return CGSize(width: width, height: totalHeight)
    }
    
    
    private func heightForLabel(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}

// MARK: - UISearchBarDelegate
extension ProductListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text?.lowercased(),
              let records = productData?.records else { return }
        
        filteredRecords = records.filter { record in
            record.fields.articleName.lowercased().contains(searchText) ||
            record.fields.articleNameInChinese.contains(searchText) ||
            record.fields.articleNumber.lowercased().contains(searchText)
        }
        
        collectionView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredRecords = productData?.records ?? []
        collectionView.reloadData()
    }
}

#Preview {
    UINavigationController(rootViewController: ProductListViewController())
}
