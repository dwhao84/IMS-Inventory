import UIKit
import Firebase
import FirebaseAuth
import IQKeyboardManagerSwift

class LoginViewController: UIViewController {
    
    let imageView = AnimatedGearView()
    
    enum TextFieldType {
        case account
        case password
    }
    
    // MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "Welcome to Inventory App!")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let acccoutTf: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = String(localized: "Enter your email")
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.rightViewMode = .whileEditing
        tf.clearButtonMode = .whileEditing
        tf.textColor = Colors.black
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passwordTf: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = String(localized: "Enter your password")
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.rightViewMode = .whileEditing
        tf.textColor = Colors.black
        tf.clearButtonMode = .whileEditing
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let loginBtn: UIButton = {
        let btn = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = Colors.black
        config.baseForegroundColor = Colors.white
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .regular),
            .foregroundColor: Colors.white
        ]
        config.attributedTitle = AttributedString(String(localized: "Login"), attributes: AttributeContainer(attributes))
        config.cornerStyle = .capsule
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.configurationUpdateHandler = { btn in
            btn.alpha = btn.isHighlighted ? 0.5 : 1
            btn.configuration = config
        }
        return btn
    }()
    
    private let registerBtn: UIButton = {
        let btn = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Colors.black
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .light),
            .foregroundColor: Colors.black
        ]
        config.attributedTitle = AttributedString(String(localized: "Register"), attributes: AttributeContainer(attributes))
        config.cornerStyle = .capsule
        config.background.strokeColor = Colors.black
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.configurationUpdateHandler = { btn in
            btn.alpha = btn.isHighlighted ? 0.5 : 1
            btn.configuration = config
        }
        return btn
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 25
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTargets()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup Functions
    private func setupStackView() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // ImageView constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        // TextFields constraints
        [acccoutTf, passwordTf].forEach { textField in
            textField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textField.widthAnchor.constraint(equalToConstant: 300),
                textField.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        // Buttons constraints
        [loginBtn, registerBtn].forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 270),
                button.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        [imageView, titleLabel, acccoutTf, passwordTf, loginBtn, registerBtn].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = Colors.white
        view.overrideUserInterfaceStyle = .light
        
        [acccoutTf, passwordTf].forEach { textField in
            textField.delegate = self
        }
        
        setupStackView()
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func addTargets() {
        loginBtn.addTarget(self, action: #selector(loginBtnTapped), for: .touchUpInside)
        registerBtn.addTarget(self, action: #selector(registerBtnTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func loginBtnTapped(_ sender: UIButton) {
        let email = acccoutTf.text ?? ""
        let password = passwordTf.text ?? ""
        
        loginBtn.configuration?.showsActivityIndicator = true
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.loginBtn.configuration?.showsActivityIndicator = false
                
                if error != nil {
                    AlertManager.showButtonAlert(
                        on: self,
                        title: Constants.error,
                        message: Constants.loginFailed
                    )
                    return
                }
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    // 創建主畫面
                    let mainVC = MainTabBarViewController()
                    
                    // 在主線程執行 UI 更新
                    DispatchQueue.main.async {
                        // 使用動畫切換畫面
                        UIView.transition(with: window,
                                       duration: 0.3,
                                       options: .transitionCrossDissolve,
                                       animations: {
                            window.rootViewController = mainVC
                            window.makeKeyAndVisible()
                        }, completion: nil)
                    }
                }
            }
        }
    }
    
    @objc private func registerBtnTapped(_ sender: UIButton) {
        let registerVC = RegisterViewController()
        let navController = UINavigationController(rootViewController: registerVC)
        present(navController, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == acccoutTf {
            passwordTf.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginBtnTapped(loginBtn)
        }
        return true
    }
}

#Preview {
    UINavigationController(rootViewController: LoginViewController())
}
