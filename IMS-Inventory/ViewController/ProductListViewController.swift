//
//  ItemTableViewController.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2023/11/9.
//

import UIKit
import Kingfisher

class ProductListViewController: UIViewController {
    
    let userTitleLabel: UILabel              = UILabel()
    let searchController: UISearchController = UISearchController()
    
    let baseUrl: String = "https://api.airtable.com/v0/app7877pVxbaMubQP/Table%201"
    
    let collectionView :UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    var productData: [Product] = []
    
    enum NetworkError: Error {
        case invaildURL
        case requestFailed
        case decodingError
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.white
        
        Task {
            await loadViews()
        }
        
        setupUI()
        addDelegateAndDataSource ()
    }
    
    // Sent to the view controller when the app receives a memory warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("didReceiveMemoryWarning")
    }
    
    func loadViews() async {
        do {
            let productsData = try await fetchImsData()
            print(productsData)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    func addDelegateAndDataSource  () {
        collectionView.delegate   = self
        collectionView.dataSource = self
        
        collectionView.register(
            ProductCollectionViewCell.self
            ,
            forCellWithReuseIdentifier: ProductCollectionViewCell.identifier
        )
    }
    
    
    func setupUI () {
        
        addConstraints()
    }
    
    func addConstraints () {
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    func fetchImsData () async throws -> [Product] {
        guard let url = URL(string: baseUrl) else {
            throw NetworkError.invaildURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkError.requestFailed
            }
            let decoder = JSONDecoder()
            let productData = try decoder.decode([Product].self, from: data)
            print(productData)
            self.productData = productData
            return productData
            
        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            throw NetworkError.decodingError
            
        } catch {
            print("Networking error: \(error)")
            throw error
        }
    }
}

extension ProductListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
        
        return cell
    }
    
    
}

#Preview {
    UINavigationController(rootViewController: ProductListViewController())
}
