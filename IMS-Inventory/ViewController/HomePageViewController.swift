//
//  HomePageViewController.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2023/11/8.
//

import UIKit

class HomePageViewController: UIViewController {

    let appTitleLabel: UILabel = UILabel()
    let userTitleLabel: UILabel = UILabel()

    let goButton: UIButton = UIButton(type: .system)

    let pickerViewTextField: UITextField = UITextField()
    let nameTextField: UITextField = UITextField()

    let pickerView: UIPickerView = UIPickerView()

    var nameList: [String] = [
        "Dawei",
        "朵朵",
        "祐紳",
        "勝淵",
        "柏勳"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red

        updateUI()

        print("Into HomePageVC")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func updateUI () {

        appTitleLabel.frame = CGRect(x: 108, y: 233, width: 215, height: 40)
        appTitleLabel.text = "IMS Inventory"
        appTitleLabel.font = UIFont.boldSystemFont(ofSize: 33)
        appTitleLabel.textColor = .darkGray
        appTitleLabel.numberOfLines = 0
        appTitleLabel.adjustsFontSizeToFitWidth = true
        appTitleLabel.textAlignment = .center
        view.addSubview(appTitleLabel)

        self.view.backgroundColor = .white

        userTitleLabel.frame = CGRect(x: 65, y: 395, width: 90, height: 30)
        userTitleLabel.text = "填入姓名"
        userTitleLabel.font = UIFont.boldSystemFont(ofSize: 21)
        userTitleLabel.textColor = .darkGray
        userTitleLabel.numberOfLines = 0
        userTitleLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(userTitleLabel)

        // pickerViewTextField
        pickerViewTextField.frame = CGRect(x: 64, y: 446, width: 300, height: 50)
        pickerViewTextField.placeholder = "選填你的名字"
        pickerViewTextField.inputView = pickerView
        pickerViewTextField.backgroundColor = UIColor.systemGray6
        pickerViewTextField.borderStyle = .roundedRect
        pickerViewTextField.keyboardType = .default
        pickerViewTextField.delegate = self
        view.addSubview(pickerViewTextField)

        pickerView(pickerViewTextField)

        // goButton
        let width: Int = 70
        let height: Int = width
        var config = UIButton.Configuration.plain()
        config.background.image = UIImage(systemName: "arrowtriangle.right.fill")
        config.background.imageContentMode = .center

        goButton.tintColor = .white
        goButton.configuration = config
        goButton.frame = CGRect(x: 300, y: 800, width: width, height: height)
        goButton.backgroundColor = .systemBlue
        goButton.isUserInteractionEnabled = true
        goButton.layer.cornerRadius = CGFloat(width / 2)
        goButton.clipsToBounds = true
        goButton.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
        view.addSubview(goButton)
    }

    func pickerView(_ : UITextField) {

        // UIPickerView
        pickerView.delegate = self
        pickerView.dataSource = self

        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(doneClick))

        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)

        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelClick))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        pickerViewTextField.inputAccessoryView = toolBar

    }

    @objc func doneClick () {
        pickerViewTextField.resignFirstResponder()
        print("doneClick")
    }

    @objc func cancelClick () {
        pickerViewTextField.resignFirstResponder()
        print("cancelClick")
    }

    @objc func goButtonTapped () {
        let listVC = ListViewController()
        listVC.modalPresentationStyle = .fullScreen
        present(listVC, animated: true)

        print("goButtonTapped")
    }


}


// MARK: - Add Protocol
extension HomePageViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIToolbarDelegate {

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
        pickerViewTextField.text      = nameList[row]
        pickerViewTextField.textColor = .darkGray
        pickerView.isHidden = false
    }

    private func textFieldDidBeginEditing(_ textField: UITextField) -> Bool {
        pickerView.isHidden = false
        print("textFieldDidBeginEditing")
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView(pickerViewTextField)
    }
}
