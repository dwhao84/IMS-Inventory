//
//  ShoppingCartViewController.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/11/2.
//

import UIKit

class CartViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = Colors.white
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI () {
        setupTableView()
        setNavigationView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        let customTitleView = CustomNavigationTitleView(title: Constants.nav_title_cart)
        navigationItem.titleView = customTitleView
        
        self.navigationController?.navigationBar.isTranslucent = true
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // Replace with your data count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        // Configure your cell here
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
}

#Preview {
    UINavigationController(rootViewController: CartViewController())
}
