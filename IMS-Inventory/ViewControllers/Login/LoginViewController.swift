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
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
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
