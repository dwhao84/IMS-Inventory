//
//  CalculationViewController.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/10/29.
//

import UIKit

class CalculationViewController: UIViewController {
    
    let segmentControl: UISegmentedControl = {
        let segmentControl: UISegmentedControl = UISegmentedControl()
        segmentControl.selectedSegmentIndex = 0
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
