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
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.tintColor = Colors.black
        imageView.layer.borderWidth = 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    let productDetailInfoLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "貨架重量: kg"
        label.textColor = Colors.darkGray
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    let stockValueLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "庫存數:"
        label.textColor = Colors.darkGray
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    let confirmBtn: ConfirmButton = {
        let btn: ConfirmButton = ConfirmButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    } ()
    
    let stepper: UIStepper = {
        let stepper: UIStepper = UIStepper()
        stepper.value = 1
        stepper.autorepeat = true
        stepper.isContinuous = true
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    } ()
    
    let qtyLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "1"
        label.textColor = Colors.darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    let stepperStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    let statusLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "狀態選擇"
        label.textColor = Colors.darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    let statusTextField: UITextField = {
        let tf: UITextField = UITextField()
        tf.text = "請選擇狀態"
        tf.borderStyle = .roundedRect
        tf.textColor = Colors.darkGray
        tf.font = UIFont.systemFont(ofSize: 20)
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    let statusStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    let dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "使用日期"
        label.textColor = Colors.darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    let dateSelectTextField: UITextField = {
        let tf: UITextField = UITextField()
        tf.text = "請選擇日期"
        tf.textColor = Colors.darkGray
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 20)
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    let dateStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    let mainStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        addTargets()
    }
    
    // MARK: - setupUI
    func setupUI() {
        setBackgroundColor()
        setNavigationView()
        configStackViews()
        addConstraints()
    }
    
    // MARK: - set BackgroundColor
    func setBackgroundColor () {
        self.view.backgroundColor = Colors.white
    }
    
    // MARK: - set NavigationView
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
    
    // MARK: - add Constraints
    func addConstraints() {
        // 1. Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        
        [dateSelectTextField, statusTextField].forEach {
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 150).isActive = true
        }
        
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // MainStackView constraints
            mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 30),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -30),
            // Make stack view width equal to scroll view width minus padding
            mainStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40),
            
            // ProductImageView constraints
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor, multiplier: 0.7),
            productImageView.widthAnchor.constraint(equalToConstant: 300),
            productImageView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            
            // ConfirmButton constraints
            confirmBtn.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 10),
            confirmBtn.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -10),
            confirmBtn.heightAnchor.constraint(equalToConstant: 60),
            confirmBtn.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: -20)
        ])
    }
    
    func configStackViews () {
        // 使用時間
        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(dateSelectTextField)
        
        // 選擇狀態
        statusStackView.addArrangedSubview(statusLabel)
        statusStackView.addArrangedSubview(statusTextField)
        
        stepperStackView.addArrangedSubview(stepper)
        stepperStackView.addArrangedSubview(qtyLabel)
        
        mainStackView.addArrangedSubview(productImageView)
        mainStackView.addArrangedSubview(articleNumberLabel)
        mainStackView.addArrangedSubview(dateStackView)
        mainStackView.addArrangedSubview(statusStackView)
        mainStackView.addArrangedSubview(productDetailInfoLabel)
        mainStackView.addArrangedSubview(stockValueLabel)
        mainStackView.addArrangedSubview(stepperStackView)
        mainStackView.addArrangedSubview(confirmBtn)
    }
    
    // MARK: - add Targets
    func addTargets () {
        confirmBtn.addTarget(self, action: #selector(confirmBtnTapped), for: .touchUpInside)
        stepper.addTarget(self, action: #selector(stepperTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc func confirmBtnTapped (_ sender: UIButton) {
        print("confirmBtnTapped")
        let shoppingCartVC = ShoppingCartViewController()
        shoppingCartVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(shoppingCartVC, animated: true)
    }
    
    @objc func stepperTapped(_ sender: UIStepper) {
        print("Stepper Tapped")
        qtyLabel.text = "\(Int(stepper.value))"
        print(qtyLabel.text!)
    }
    
}

extension ProductDetailViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textField Did Begin Editing")
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textField Did End Editing")
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("textField Should Return")
        return true
    }
}

#Preview {
    UINavigationController(rootViewController: ProductDetailViewController())
}
