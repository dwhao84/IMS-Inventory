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

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.layer.borderColor  = Colors.lightGray.cgColor
        collectionView.layer.borderWidth  = 0.2
        collectionView.layer.cornerRadius = 5
        collectionView.clipsToBounds      = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = Colors.white
        return collectionView
    }()

    // MARK: - SearchController:
    let searchController: UISearchController = {
        let controller: UISearchController = UISearchController()
        controller.automaticallyShowsCancelButton = true
        controller.searchBar.placeholder = "Item, Article No, Description"
        controller.isActive = true
//        controller.searchBar.searchTextField.textColor = Colors.darkGray
        controller.obscuresBackgroundDuringPresentation = true         // 新增當點選searchBar時，背景會產生半透明的效果。
        return controller
    } ()
    
    
    // MARK: - Life Cycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.CustomBackgroundColor
        
        setupUI()
        fetchData()
    }
    
    // MARK: - Sent to the view controller when the app receives a memory warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("didReceiveMemoryWarning")
    }
    
    func setupUI() {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.backgroundColor = Colors.darkGray
        self.navigationController?.navigationBar.standardAppearance = standardAppearance
        
        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.backgroundColor = Colors.white
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
    
    func addDelegateAndDataSource() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            ProductCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductCollectionViewCell.identifier
        )
        collectionView.allowsSelection = true
    }
    
    func addConstraints() {
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
//    func fetchImsData() async throws -> Product {
//        guard let url = URL(string: baseUrl) else {
//            throw NetworkError.invalidURL
//        }
//        var request = URLRequest(url: url)
//        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        
//        do {
//            let (data, response) = try await URLSession.shared.data(for: request)
//            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                throw NetworkError.requestFailed
//            }
//            
//            let decoder = JSONDecoder()
//            let productData = try decoder.decode(Product.self, from: data)
//            print(productData)
//            
//        } catch let decodingError as DecodingError {
//            print("Decoding error: \(decodingError)")
//            throw NetworkError.decodingError
//            
//        } catch {
//            print("Networking error: \(error)")
//            throw error
//        }
//        return productData!
//    }
    
    func fetchData () {
        guard let url = URL(string: baseUrl) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
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
        let productUrl = productData?.records[indexPath.row].fields.image.last?.url
        
        
        cell.articleNumberLabel.text = product?.fields.articleNumber
        cell.productENNameLabel.text = product?.fields.articleName
        cell.productTCNameLabel.text = product?.fields.articleNameInChinese
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
