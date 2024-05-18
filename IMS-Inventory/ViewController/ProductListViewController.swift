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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupUI()
        
    }

    // Sent to the view controller when the app receives a memory warning.
    override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
          // Dispose of any resources that can be recreated.
        print("didReceiveMemoryWarning")
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

//    func configureSearchController () {
//        // searchController
//        searchController.searchResultsUpdater = self
//        searchController.automaticallyShowsCancelButton = true
//        searchController.searchBar.placeholder = "Search the article"
//        searchController.isActive = true
//
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
//        definesPresentationContext = true
//    }


    func fetchData () {
//        let productURL = " https://api.airtable.com/v0/app7877pVxbaMubQP/Table%201 \"


    }


}

//// tableView
//extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.textLabel?.text = "Row \(indexPath.row)"
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("didSelectRowAt")
//    }
//
//    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        print("shouldHighlightRowAt")
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(
//            style: .destructive, title: "Delete") { (action, view, completionHandler) in
//            // Perform your deletion logic here
//
//            // Call completion handler to dismiss the action button
//            completionHandler(true)
//        }
//        // Optionally, you can customize the appearance of the deleteAction here
//        // Return the configured UISwipeActionsConfiguration
//        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
//        return configuration
//    }
//}
//
//// UISearchBar
//extension ProductListViewController: UISearchResultsUpdating {
//
//    func updateSearchResults(for searchController: UISearchController) {
//
//    }
//
//}


#Preview {
    UINavigationController(rootViewController: ProductListViewController())
}
