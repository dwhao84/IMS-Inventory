//
//  LoginViewController.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/11/27.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    
    private let acccoutTf: UITextField = {
        let tf: UITextField = UITextField()
        tf.borderStyle = .roundedRect
        tf.text = "Enter your email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    private let passwordTf: UITextField = {
        let tf: UITextField = UITextField()
        tf.borderStyle = .roundedRect
        tf.text = "Enter your password"
        tf.rightViewMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    // stackView
     private let stackView: UIStackView = {
         let stackView: UIStackView = UIStackView()
         stackView.axis             = .vertical
         stackView.alignment        = .center
         stackView.spacing          = 25
         stackView.distribution     = .fill
         stackView.translatesAutoresizingMaskIntoConstraints = false
         return stackView
     } ()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    
    func setupUI () {
        
    }
    
    
}

#Preview {
    UINavigationController(rootViewController: LoginViewController())
}
