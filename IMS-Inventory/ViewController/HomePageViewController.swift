//
//  HomePageViewController.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2023/11/8.
//

import UIKit

class HomePageViewController: UIViewController {

    let userTitleLabel: UILabel = UILabel()


    let pickTextField: UITextField = UITextField()
    let nameTextField: UITextField = UITextField()

    let pickerView: UIPickerView = UIPickerView()

    var nameList: [String] = [ "Dawei", "朵朵", "祐紳", "勝淵", "柏勳" ]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red

        updateUI()

        print("Into HomePageVC")
    }

    func updateUI () {

        self.view.backgroundColor = .white

        userTitleLabel.frame = CGRect(x: 80, y: 303, width: 86, height: 26)
        userTitleLabel.text = "填入姓名"
        userTitleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        userTitleLabel.textColor = .darkGray
        userTitleLabel.numberOfLines = 0
        userTitleLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(userTitleLabel)

        // pickTextField
        pickTextField.frame = CGRect(x: 80, y: 350, width: 270, height: 30)
        pickTextField.placeholder = "選填你的名字"
        pickTextField.inputView = pickerView
        pickTextField.backgroundColor = UIColor.systemGray6
        pickTextField.borderStyle = .roundedRect
        pickTextField.keyboardType = .default
        pickTextField.delegate = self
        view.addSubview(pickTextField)

//        nameTextField.placeholder = ""

        AddDelegate()
    }


    // MARK: - Add delegate
    func AddDelegate () {
        pickTextField.delegate = self

        // pickView
        pickerView.delegate = self
        pickerView.dataSource = self
    }



}


// MARK: - Add Protocol
extension HomePageViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return nameList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = nameList[row]
        return row
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickTextField.text = nameList[row]
        pickerView.isHidden = true
    }

    private func textFieldDidBeginEditing(_ textField: UITextField) -> Bool {
        pickerView.isHidden = false
        print("textFieldDidBeginEditing")
        return false
    }
}
