//
//  CalculationViewController.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/10/29.
//

import UIKit

class CalculationViewController: UIViewController {

    let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.insertSegment(withTitle: String(localized:"Bins"), at: 0, animated: true)
        segmentControl.insertSegment(withTitle: String(localized:"Gondola"), at: 1, animated: true)
        segmentControl.insertSegment(withTitle: String(localized:"Backwall"), at: 2, animated: true)
        segmentControl.insertSegment(withTitle: String(localized:"Shelving System"), at: 3, animated: true)
        segmentControl.selectedSegmentIndex = 0
        
        let segmentWidths = [80, 90, 90, 150]
        for (index, width) in segmentWidths.enumerated() {
            segmentControl.setWidth(CGFloat(width), forSegmentAt: index)
        }
        
        // 設定正常狀態(未選中)的外觀
        segmentControl.setTitleTextAttributes([
            .foregroundColor: Colors.black,
        ], for: .normal)
        
        // 設定選中狀態的外觀
        segmentControl.setTitleTextAttributes([
            .foregroundColor: Colors.white,
            .backgroundColor: Colors.black
        ], for: .selected)
        
        // 設定選中時的背景顏色
        segmentControl.selectedSegmentTintColor = Colors.black
        segmentControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI () {
        self.view.backgroundColor = Colors.white
        setNavigationView()
        addConstraints()
    }
    
    func setNavigationView() {
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
    
    func addConstraints () {
        self.view.addSubview(segmentControl)
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            segmentControl.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
}

#Preview {
    UINavigationController(rootViewController: CalculationViewController())
}
