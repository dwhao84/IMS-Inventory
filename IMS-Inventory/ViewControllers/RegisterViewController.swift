import UIKit
import Firebase
import FirebaseAuth
import SwiftUI
import IQKeyboardManagerSwift

// MARK: - RegisterViewController
class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var hostingController: UIHostingController = {
        let hostingController = UIHostingController(rootView: PersonalAnimatedView())
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        return hostingController
    }()
    
    private let accountTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = String(localized: "E-mail")
        tf.font = .systemFont(ofSize: 16)
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.clearButtonMode = .whileEditing
        tf.textColor = .customBlack
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = String(localized: "Password")
        tf.font = .systemFont(ofSize: 16)
        tf.clearButtonMode = .whileEditing
        tf.textColor = .customBlack
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .customBlack
        config.baseForegroundColor = .customWhite
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: UIColor.customWhite
        ]
        config.attributedTitle = AttributedString(String(localized: "Register"), attributes: AttributeContainer(attributes))
        config.cornerStyle = .capsule
        
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        button.configurationUpdateHandler = { button in
            button.alpha = button.isHighlighted ? 0.7 : 1.0
        }
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Into the RegisterViewController")
        
        setupUI()
        setupGestures()
        IQKeyboardManager.shared.isEnabled = true
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.overrideUserInterfaceStyle = .light
        self.view.backgroundColor = Colors.white
        
        // Add hosting controller
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        // Setup stack view
        setupStackView()
        
        // Add constraints
        setupConstraints()
        
        // Setup delegates
        accountTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setupStackView() {
        stackView.addArrangedSubview(accountTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(registerButton)
        view.addSubview(stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Hosting Controller Constraints
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            hostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hostingController.view.widthAnchor.constraint(equalToConstant: 180),
            hostingController.view.heightAnchor.constraint(equalToConstant: 180),
            
            // Stack View Constraints
            stackView.topAnchor.constraint(equalTo: hostingController.view.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            // Text Fields Constraints
            accountTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Register Button Constraints
            registerButton.heightAnchor.constraint(equalToConstant: 50),

        ])
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc func dismissKeyboard(_ sender: UIButton) {
        view.endEditing(true)
    }
    
    @objc func registerButtonTapped() {
        // Add Analytics
        Analytics.logEvent("RegisterVC_RegisterBtn", parameters: nil)
        
        guard let email = accountTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            AlertManager.showButtonAlert(
                on: self,
                title: String(localized: "Error"),
                message: String(localized: "Please fill in the information")
            )
            return
        }
        
        registerButton.configuration?.showsActivityIndicator = true
        registerButton.isEnabled = false
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.registerButton.configuration?.showsActivityIndicator = false
                self.registerButton.isEnabled = true
            }
            
            if let error = error {
                let errorMessage: String
                
                switch error.localizedDescription {
                    case let str where str.contains("email address is badly formatted"):
                        errorMessage = String(localized: "Please enter a valid email address")
                    case let str where str.contains("email address is already in use"):
                    errorMessage = String(localized: "This email has already been registered")
                    case let str where str.contains("Password should be at least 6 characters"):
                        errorMessage = String(localized: "Password must be at least 6 characters")
                    default:
                        errorMessage = String(localized: "An error occurred during registration, please try again later")
                }
                
                AlertManager.showButtonAlert(
                    on: self,
                    title: String(localized: "Register Failed"),
                    message: errorMessage
                )
                return
            }
            
            // Success case
            AlertManager.showButtonAlert(
                on: self,
                title: String(localized: "Reigster Success"),
                message: String(localized: "Account has been successfully created")
            )
            
            // Clear text fields
            self.accountTextField.text = ""
            self.passwordTextField.text = ""
        }
    }
}
    

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == accountTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - Colors Extension
extension UIColor {
    static let customBlack = UIColor(named: "black") ?? .black
    static let customWhite = UIColor(named: "white") ?? .white
}

#Preview {
    UINavigationController(rootViewController: RegisterViewController())
}
