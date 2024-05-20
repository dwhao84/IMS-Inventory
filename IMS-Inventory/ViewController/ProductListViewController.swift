//
//  ItemTableViewController.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2023/11/9.
//

import UIKit
import Kingfisher

class ProductListViewController: UIViewController {
    
    let baseUrl: String = "https://api.airtable.com/v0/app7877pVxbaMubQP/Table%201"
    var productData: Product?
    
    private let apiKey: String = "pat1LqVaDimhjw3Zf.b43913585307f91de54e59d08120eb228c2d09c777a0c10250ba3a5aab67bcf4"
    
    // MARK: - Checking Networking:
    enum NetworkError: Error {
        case invalidURL
        case requestFailed
        case decodingError
    }
    
    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - CollectionView:
    let collectionView: UICollectionView = {
        let itemSpace:   CGFloat = 5
        let columnCount: CGFloat = 2
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
//        flowLayout.collectionView?.layer.borderColor = Colors.darkGray.cgColor
//        flowLayout.collectionView?.layer.borderWidth = 2
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = Colors.CustomBackgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var refreshControl: UIRefreshControl = {
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.tintColor = Colors.IKEA_Blue
        return refreshControl
    } ()

    // MARK: - SearchController:
    let searchController: UISearchController = {
        let controller: UISearchController = UISearchController()
        controller.automaticallyShowsCancelButton = true
        controller.searchBar.placeholder = "Item, Article No, Description"
        controller.isActive = true
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
        
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
    }
    
    // MARK: - Sent to the view controller when the app receives a memory warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("didReceiveMemoryWarning")
    }
    
    func setupUI() {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.backgroundColor = Colors.CustomBackgroundColor
        self.navigationController?.navigationBar.standardAppearance = standardAppearance
        
        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.backgroundColor = Colors.CustomBackgroundColor
        self.navigationController?.navigationBar.scrollEdgeAppearance = scrollAppearance

        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.darkGray]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.navigationItem.title = "IMS Stock Qty"
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.navigationItem.searchController = searchController
        
        addDelegateAndDataSource()
        addConstraints()
    }
    
    // 定義一個自訂的字型，如果不行 回傳systemFont
    static func scriptFont(size: CGFloat) -> UIFont {
      guard let customFont = UIFont(name: "NotoIKEATraditionalChinese-Bold", size: size) else {
        return UIFont.systemFont(ofSize: size)
      }
      return customFont
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
    
    func fetchData () {
        guard let url = URL(string: baseUrl) else {
            return
        }
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false // 禁用用戶交互
        }
              
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                 self.activityIndicator.stopAnimating()
                 self.view.isUserInteractionEnabled = true // 恢復用戶交互
             }
            
            if let error = error {
                print("DEBUG PRINT: Request error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("DEBUG PRINT: No data received")
                return
            }
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Product.self, from: data)
                
                DispatchQueue.main.async {
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

    
    // MARK: - Handle device rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            let itemSpace: CGFloat = 5
            let columnCount: CGFloat = 2
            let width = floor((size.width - itemSpace * (columnCount - 1)) / columnCount)
            if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.itemSize = CGSize(width: width, height: width)
                self.collectionView.collectionViewLayout.invalidateLayout()
            }
        }, completion: nil)
    }
}

extension ProductListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productData?.records.count ?? 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
        
        let product = productData?.records[indexPath.row]
        
        cell.articleNumberLabel.text = " \(product?.fields.articleNumber ?? "Loading...") "
        cell.productENNameLabel.text = " \(product?.fields.articleName ?? "Loading...") "
        cell.productTCNameLabel.text = " \(product?.fields.articleNameInChinese ?? "Loading...") "
        
        // 假設Product有一個name屬性
        // 使用 Kingfisher 加載圖片
        if let imageUrlString = productData?.records[indexPath.row].fields.image.last?.url, let url = URL(string: imageUrlString) {
            cell.productImageView.kf.setImage(with: url)
        } else {
            cell.productImageView.image = Images.image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
}

#Preview {
    UINavigationController(rootViewController: ProductListViewController())
}
