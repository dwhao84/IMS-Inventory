//
//  Constantns.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/12/1.
//

import UIKit

struct Constants {
    // MARK: - Login VC
    static let login: String                = "Login"
    static let register: String             = "Register"
    static let welcome_quote: String        = "Welcome to Inventory App!"
    static let enter_your_mail: String      = "Enter your email"
    static let enter_your_password: String  = "Enter your password"
    static let error: String                = "Error"
    static let loginFailed: String          = "Login Failed"
    
    // MARK: - Register VC
    static let email: String                = "E-mail"
    static let password: String             = "Password"
    static let fill_in_info: String         = "Please fill in the information"
    static let registerFailed: String       = "Register Failed"
    
    // MARK: - Product List VC
    static let racking_status: String       = "Racking Status"
    
    
    // MARK: - Product Detail VC
    static let product_name: String       = "Product name"
    static let fillYourName: String       = "Fill your name"
    static let fill: String       = "Fill"
    
    // MARK: - MainTabBarController
    static let calculation: String  = "Calculation"
    static let settings: String     = "Settings"
    static let list: String         = "List"
    
    // MARK: - Shopping VC
    static let cart: String         = "Cart"
    
    // MARK: - Setting VC
    static let settingNavigationTitle: String = "Settings"
    
    // MARK:  Services
    static let disclaimer: String   = "Disclaimer"
    static let version: String      = "Version V 1.1.0"
    static let report: String       = "Problem Report"
    
    // Title:
    static let nav_title_cart: String         = "Cart"
    static let nav_title_calculation: String  = "Calculation"
    static let nav_title_settings: String     = "Settings"
    static let nav_title_list: String         = "List"
    static let nav_title_detail: String       = "Product Detail"
    
    static let status: String                 = "Status"
    static let searchBar_placeHolder: String  = "Item, Article No, Description"
    
    static let sortByArticleNoAsc: String = "Article No: Ascending"
    static let sortByArticleNoDesc: String = "Article No: Descending"
    static let sortByNameAZ: String = "Name: A to Z"
    static let sortByQuantityDesc: String = "Quantity: High to Low"
    
    static let delete: String = "Delete"
    static let deleteFailed: String = "Delete Failed"
    
    static let send: String = "Send"
}

struct AlertConstants {
    static let error: String                = "Error"
    static let loginFailed: String          = "Login Failed"
    static let emptyQty: String             = "Qty is empty"
}


struct LocalizedString {
    static let invalid_email: String        = "Please enter a valid email address"
    static let email_already_exists: String = "This email has already been registered"
    static let password_too_short: String   = "Password must be at least 6 characters"
    static let register_error: String       = "An error occurred during registration, please try again later"
}
