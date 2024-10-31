//
//  ProductDetailViewController.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/10/31.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    let productImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = Images.photoLibrary
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.systemBlue.cgColor
        imageView.layer.borderWidth = 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
//    let productTitleLabel: UILabel = {
//        let label: UILabel = UILabel()
//        label.text = ""
//        label.textColor = Colors.darkGray
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//        label.textAlignment = .left
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    } ()
    
    let productDetailInfoLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = ""
        label.textColor = Colors.darkGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    let technicalSpecsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = ""
        label.textColor = Colors.darkGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    let articleNumberLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "No.10150"
        label.textColor = Colors.white
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.backgroundColor = Colors.black
        label.textAlignment = .center
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    let confirmBtn: ConfirmButton = {
        let btn: ConfirmButton = ConfirmButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    } ()
    
    let lineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = Colors.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    let scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    func setupUI() {
        configBackgroundColor()
        setNavigationView()
        addConstraints()
    }
    
    func configBackgroundColor () {
        self.view.backgroundColor = Colors.white
    }
    
    func setNavigationView () {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = "Product Name"
        
        // Add appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = Colors.clear
        
        let scrollingAppearance = UINavigationBarAppearance()
        scrollingAppearance.configureWithTransparentBackground()
        scrollingAppearance.backgroundColor = Colors.clear
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    func addConstraints() {
        self.view.addSubview(productImageView)
        self.view.addSubview(articleNumberLabel)
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            productImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            productImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor, multiplier: 0.7),
            articleNumberLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 20),
            articleNumberLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20)
        ])
    }
}

#Preview {
    UINavigationController(rootViewController: ProductDetailViewController())
}
