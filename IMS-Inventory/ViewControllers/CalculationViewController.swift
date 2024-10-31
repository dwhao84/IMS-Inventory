//
//  CalculationViewController.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/10/29.
//

import UIKit

class CalculationViewController: UIViewController {
    
    let largeTitle: String = "Calculations"
    
    let segmentControl: UISegmentedControl = {
        let segmentControl: UISegmentedControl = UISegmentedControl()
        segmentControl.insertSegment(withTitle: "Bins", at: 0, animated: true)
        segmentControl.insertSegment(withTitle: "Gondola", at: 1, animated: true)
        segmentControl.insertSegment(withTitle: "Backwall", at: 2, animated: true)
        segmentControl.insertSegment(withTitle: "Shelving System", at: 3, animated: true)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI () {
        self.view.backgroundColor = Colors.white
        setNavigationView()
        addConstraints()
    }
    
    func setNavigationView () {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = largeTitle
        
        // 創建並配置 NavigationBar 外觀
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 使用不透明背景
        
        // 設置背景顏色
        appearance.backgroundColor = .systemBackground
        
        // 設置標題顏色
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        // 重要：同時設置這三種外觀狀態
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // 確保即時更新外觀
        navigationController?.navigationBar.tintColor = .label
    }
    
    
    func addConstraints () {
        self.view.addSubview(segmentControl)
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentControl.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

#Preview {
    UINavigationController(rootViewController: CalculationViewController())
}
