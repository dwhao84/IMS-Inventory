//
//  LoginViewController.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/11/27.
//

import UIKit

class LoginViewController: UIViewController {
    
    let imageView = AnimatedGearView()
    
    enum TextFieldType {
        case account
        case password
    }
    
    let titleLabel: UILabel = {
        let label = UILabel ()
        label.text = "Welcome to Inventory App!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    // MARK: - Button
    var loginBtn: UIButton = {
        let btn = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = Colors.black
        config.baseForegroundColor = Colors.white
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .regular),
            .foregroundColor: Colors.white
        ]
        config.attributedTitle = AttributedString("Login", attributes: AttributeContainer(attributes))
        config.cornerStyle = .capsule
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.configurationUpdateHandler = { btn in
            btn.alpha = btn.isHighlighted ? 0.5 : 1
            btn.configuration = config
        }
        return btn
    } ()
    
    // MARK: - Button
    var registerBtn: UIButton = {
        let btn = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Colors.black
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .light),
            .foregroundColor: Colors.black
        ]
        config.attributedTitle = AttributedString("Register", attributes: AttributeContainer(attributes))
        config.cornerStyle = .capsule
        config.background.strokeColor = Colors.black
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.configurationUpdateHandler = { btn in
            btn.alpha = btn.isHighlighted ? 0.5 : 1
            btn.configuration = config
        }
        return btn
    } ()
    
    // MARK: - TextField
    private let acccoutTf: UITextField = {
        let tf: UITextField = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Enter your email"
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.rightViewMode = .whileEditing
        tf.textColor = Colors.black
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    // MARK: - TextField
    private let passwordTf: UITextField = {
        let tf: UITextField = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Enter your password"
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.rightViewMode = .whileEditing
        tf.textColor = Colors.black
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    // MARK: - StackView
     private let stackView: UIStackView = {
         let stackView: UIStackView = UIStackView()
         stackView.axis             = .vertical
         stackView.alignment        = .center
         stackView.spacing          = 25
         stackView.distribution     = .fill
         stackView.translatesAutoresizingMaskIntoConstraints = false
         return stackView
     } ()

    // MARK: - Life Cycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - set up stackView
    func setupStackView () {
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        // TextFields
        [acccoutTf, passwordTf].forEach {
            $0.widthAnchor.constraint(equalToConstant: 300).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        [loginBtn, registerBtn].forEach {
            $0.widthAnchor.constraint(equalToConstant: 270).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(acccoutTf)
        stackView.addArrangedSubview(passwordTf)
        stackView.addArrangedSubview(loginBtn)
        stackView.addArrangedSubview(registerBtn)
    }
    
    // MARK: - set up UI
    func setupUI () {
        acccoutTf.delegate = self
        passwordTf.delegate = self
        
        // Set up StackView
        setupStackView()
        self.view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func addTargets () {
        loginBtn.addTarget(self, action: #selector(loginBtnTapped), for: .touchUpInside)
        registerBtn.addTarget(self, action: #selector(registerBtnTapped), for: .touchUpInside)
    }
    
    // MARK: - Buttons
    @objc func loginBtnTapped (_ sender: UIButton) {
        print("=== login Btn Tapped ===")
        let productListVC = ProductListViewController()
        self.navigationController?.pushViewController(productListVC, animated: true)
    }
    
    @objc func registerBtnTapped (_ sender: UIButton) {
        print("=== register Btn Tapped ===")
        let registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("=== textField Should Clear ===")
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("=== textField Did Begin Editing ===")
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("=== textField Did End Editing ===")
        textField.resignFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
       let type: TextFieldType = textField == acccoutTf ? .account : .password
       switch type {
       case .account:
           print("Account Text Field: \(textField.text ?? "")")
       case .password:
           print("Password Text Field: \(textField.text ?? "")")
       }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textField Should Return")
        textField.resignFirstResponder()
        return true
    }
}

#Preview {
    UINavigationController(rootViewController: LoginViewController())
}
