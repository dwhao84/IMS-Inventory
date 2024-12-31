//
//  CalculationViewController.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/10/29.
//

import UIKit

class CalculationViewController: UIViewController {
    
    let segmentedControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.insertSegment(withTitle: "Bins", at: 0, animated: true)
        segmentControl.insertSegment(withTitle: "Shelving System", at: 1, animated: true)
        segmentControl.insertSegment(withTitle: "Backwall", at: 2, animated: true)

        segmentControl.selectedSegmentIndex = 0
        // 設定正常狀態(未選中)的外觀
        segmentControl.setTitleTextAttributes([
            .foregroundColor: Colors.black,
        ], for: .normal)
        
        // 設定選中狀態的外觀
        segmentControl.setTitleTextAttributes([
            .foregroundColor: Colors.white,
            .backgroundColor: Colors.black
        ], for: .selected)
        
        // 設定選中時的背景顏色和移除分隔線
        segmentControl.selectedSegmentTintColor = Colors.black
        segmentControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var currentViewController: UIViewController?
    
    // View Controllers
    private lazy var binVC: UIViewController = {
        let vc = BinViewController()
        return vc
    }()
    
    private lazy var shelvingVC: UIViewController = {
        let vc = ShelvingSystemViewController()
        return vc
    }()
    
    private lazy var rackingVC: UIViewController = {
        let vc = RackingCalculatorViewController()
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Into the CalculationViewController")
        
        setupUI()
        switchToViewController(binVC) // 初始顯示 BinViewController
    }
    
    private func setupUI() {
        self.view.backgroundColor = Colors.white
        setNavigationView()
        
        // 添加視圖
        view.addSubview(segmentedControl)
        view.addSubview(containerView)
        
        addConstraints()
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    private func setNavigationView() {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithDefaultBackground()
        self.navigationController?.navigationBar.standardAppearance = standardAppearance
        
        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.configureWithDefaultBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance = scrollAppearance
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.darkGray]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        // 使用客製化的標題視圖
        let customTitleView = CustomNavigationTitleView(title: String(localized: "Calculation"))
        navigationItem.titleView = customTitleView
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            // Segmented Control 約束
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            // Container View 約束
            containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            switchToViewController(binVC)
            print("=== Switch to Bin VC ===")
        case 1:
            switchToViewController(shelvingVC)  
            print("=== Switch to Shelving VC ===")
        case 2:
            switchToViewController(rackingVC)
            print("=== Switch to Racking VC ===")
        default:
            break
        }
    }
    
    private func switchToViewController(_ viewController: UIViewController) {
        // 移除當前的 ViewController
        currentViewController?.willMove(toParent: nil)
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()
        
        // 添加新的 ViewController
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.didMove(toParent: self)
        
        currentViewController = viewController
    }
    
    private func tapGesture () {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissPicker (_ sender: UITapGestureRecognizer) {
        print("DEBUG PRIN: dismissPicker")
        view.endEditing(true)
    }
}

#Preview {
    UINavigationController(rootViewController: CalculationViewController())
}
