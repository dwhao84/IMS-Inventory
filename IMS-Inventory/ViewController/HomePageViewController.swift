//
//  HomePageViewController.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2023/11/8.
//

import UIKit
import AVFoundation
import Vision
import VisionKit

class HomePageViewController: UIViewController {

    // UILabel
    let appTitleLabel:  UILabel = UILabel()
    let userTitleLabel: UILabel = UILabel()

    // titleLabel
    let articleNumberTitleLabel: UILabel = UILabel()
    let qtyTitleLabel: UILabel           = UILabel()
    let dateSelectTitleLabel: UILabel    = UILabel()

    // For status
    var articleNumberStatusLabel: UILabel = UILabel()
    var qtyStatusLabel: UILabel           = UILabel()

    // UIButton
    let goButton: UIButton = UIButton(type: .system)

    // UITextFleid
    let pickerViewTextField:    UITextField = UITextField()
    let nameTextField:          UITextField = UITextField()

    let articleNumberTextField: UITextField = UITextField()
    let qtyTextField:           UITextField = UITextField()

    // UIPickerView
    let pickerView: UIPickerView = UIPickerView()

    // DatePicker
    let datePicker: UIDatePicker = UIDatePicker()

    // UISegmentedControl
    var segmentedControl: UISegmentedControl = UISegmentedControl()

    /// UIStackView
    let overallStackView: UIStackView                    = UIStackView()
    let appNameAndSegmentedControlStackView: UIStackView = UIStackView()

    // nameTextField & userTitleLabel
    let fillYourNameStackView:    UIStackView = UIStackView()

    // datePickerLabel & datePicker
    let datePickerStackView:      UIStackView = UIStackView()



    var nameList: [String] = [
        "大緯 Dawei",
        "朵朵 Doris",
        "祐紳 John",
        "勝淵 Sam",
        "柏勳 Bosh"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        print("Into HomePageVC")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Configure UI
    func configureUI () {

        view.backgroundColor = .white

        // UILabel
        configureAppTitleLabel()
        configureUserTitleLabel()

        configureArticleNumberStautsLabel()
        configureqtyStatusLabel()

        configureQtyTitleLabel()
        configureArticleNumberTitleLabel()
        configureDateSelectTitleLabel()

        // UIUSegmentedControl
        configureSegmentedControl()

        // UIButton
        configureGoButton()
        congfigurePickerView()

        // UITextField
        configureQtyTextField()
        configureArticleNameTextField()

        // UIDatePicker
        configureDatePicker()

        // hideKeyboard
        hideKeyboard()
    }
    // MARK: - Configure UITextField

    func configureArticleNameTextField () {
        // configure scannerButton
        let scannerButton: UIButton = UIButton(type: .system)
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "qrcode")
        configuration.baseForegroundColor = SystemColor.blueColor
        scannerButton.configuration = configuration
        scannerButton.addTarget(self, action: #selector(scannerButtonTapped), for: .touchUpInside)

        articleNumberTextField.rightView = scannerButton
        articleNumberTextField.rightViewMode = .always

        // textField delegate
        articleNumberTextField.delegate = self

        // custom articleNumberTextField
        articleNumberTextField.frame = CGRect(x: 64, y: 333, width: 140, height: 50)
        articleNumberTextField.placeholder =
        "請輸入貨號 Please fill the article Number"
        articleNumberTextField.adjustsFontSizeToFitWidth = true
        articleNumberTextField.font = UIFont.systemFont(ofSize: 15)
        articleNumberTextField.borderStyle = .roundedRect
        articleNumberTextField.backgroundColor = UIColor.systemGray6
        articleNumberTextField.keyboardType = .numberPad
        view.addSubview(articleNumberTextField)

        // Add action
        articleNumberTextField.addTarget(self, action: #selector(articleNumberTextFieldTapped), for: .touchUpInside)

//        articleNumberTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        articleNumberTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        checkArticleNumberCorrection ()
    }

    func configureQtyTextField () {
        // textField delegate
        qtyTextField.delegate = self

        qtyTextField.frame = CGRect(x: 224, y: 333, width: 140, height: 50)
        qtyTextField.placeholder = "請輸入數量"
        qtyTextField.keyboardType = .numberPad
        qtyTextField.font = UIFont.systemFont(ofSize: 15)
        qtyTextField.borderStyle = .roundedRect
        qtyTextField.backgroundColor = UIColor.systemGray6
        view.addSubview(qtyTextField)

        qtyTextField.addTarget(self, action: #selector(qtyTextFieldTapped), for: .touchUpInside)

//        qtyTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        qtyTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true

    }


    // MARK: - Configure UISegmented Control

    func configureSegmentedControl () {
        let items: [String] = ["借出 Borrow", "歸還 Return", "其他 Rest"]
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl.frame = CGRect(x: 64, y: 233, width: 300, height: 35)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.isUserInteractionEnabled = true
        view.addSubview(segmentedControl)

        segmentedControl.addTarget(self, action: #selector(segmentedControlTapped), for: .valueChanged)

//        segmentedControl.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    // MARK: - Configure UIPickerView
    func congfigurePickerView () {
        // textField delegate
        pickerViewTextField.delegate = self

        // pickerViewTextField
        pickerViewTextField.frame = CGRect(x: 64, y: 470, width: 300, height: 50)
        pickerViewTextField.placeholder = "選填你的名字 Please fill your name"
        pickerViewTextField.font = UIFont.systemFont(ofSize: 15)

        pickerViewTextField.backgroundColor = UIColor.systemGray6
        pickerViewTextField.borderStyle = .roundedRect
        pickerViewTextField.keyboardType = .default
        pickerViewTextField.inputView = pickerView

        view.addSubview(pickerViewTextField)
        configurePickerView(pickerViewTextField)

//        pickerViewTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        pickerViewTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    // MARK: - Configure UILabel

    // appTitleLabel
    func configureAppTitleLabel () {
        appTitleLabel.frame = CGRect(x: 64, y: 150, width: 300, height: 50)
        appTitleLabel.text = "IMS Inventory"
        appTitleLabel.font = UIFont.boldSystemFont(ofSize: 35)
        appTitleLabel.textColor = .darkGray
        appTitleLabel.numberOfLines = 0
        appTitleLabel.adjustsFontSizeToFitWidth = true
        appTitleLabel.textAlignment = .center
        view.addSubview(appTitleLabel)

//        appTitleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        appTitleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func configureQtyTitleLabel () {
        qtyTitleLabel.frame = CGRect(x: 224, y: 303, width: 300, height: 20)
        qtyTitleLabel.text = "填入數量:"
        qtyTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        qtyTitleLabel.textAlignment = .left
        qtyTitleLabel.textColor = UIColor.darkGray
        qtyTitleLabel.numberOfLines = 0
        qtyTitleLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(qtyTitleLabel)

//        qtyTitleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        qtyTitleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func configureArticleNumberTitleLabel () {
        articleNumberTitleLabel.frame = CGRect(x: 65, y: 303, width: 300, height: 20)
        articleNumberTitleLabel.text = "填入貨號:"
        articleNumberTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        articleNumberTitleLabel.textAlignment = .left
        articleNumberTitleLabel.textColor = UIColor.darkGray
        articleNumberTitleLabel.numberOfLines = 0
        articleNumberTitleLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(articleNumberTitleLabel)

//        articleNumberTitleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        articleNumberTitleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func configureDateSelectTitleLabel () {
        dateSelectTitleLabel.frame = CGRect(x: 65, y: 545, width: 300, height: 20)
        dateSelectTitleLabel.text = "填入借出日期:"
        dateSelectTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        dateSelectTitleLabel.textAlignment = .left
        dateSelectTitleLabel.textColor = UIColor.darkGray
        dateSelectTitleLabel.numberOfLines = 0
        dateSelectTitleLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(dateSelectTitleLabel)
    }

    // userLabel
    func configureUserTitleLabel () {
        userTitleLabel.frame = CGRect(x: 65, y: 435, width: 300, height: 30)
        userTitleLabel.text = "填入姓名:"
        userTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        userTitleLabel.textAlignment = .left
        userTitleLabel.textColor = .darkGray
        userTitleLabel.numberOfLines = 0
        userTitleLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(userTitleLabel)

//        userTitleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        userTitleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func configureArticleNumberStautsLabel () {
        articleNumberStatusLabel.frame = CGRect(x: 65, y: 388, width: 300, height: 20)
        articleNumberStatusLabel.text = "請輸入五位數字"
        articleNumberStatusLabel.font = UIFont.boldSystemFont(ofSize: 12)
        articleNumberStatusLabel.textAlignment = .left
        articleNumberStatusLabel.textColor = UIColor.systemPink
        articleNumberStatusLabel.numberOfLines = 0
        articleNumberStatusLabel.adjustsFontSizeToFitWidth = true
        articleNumberStatusLabel.isHidden = true
        view.addSubview(articleNumberStatusLabel)

//        articleNumberStatusLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        articleNumberStatusLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    // qtyStatusLabel
    func configureqtyStatusLabel () {
        qtyStatusLabel.frame = CGRect(x: 224, y: 388, width: 300, height: 20)
        qtyStatusLabel.text = "數量狀態"
        qtyStatusLabel.font = UIFont.boldSystemFont(ofSize: 12)
        qtyStatusLabel.textAlignment = .left
        qtyStatusLabel.textColor = UIColor.systemPink
        qtyStatusLabel.numberOfLines = 0
        qtyStatusLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(qtyStatusLabel)

        qtyStatusLabel.isHidden = true

//        qtyStatusLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        qtyStatusLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    // MARK: - Configure UIButton
    // goButton
    func configureGoButton () {
        var config = UIButton.Configuration.plain()
//        config.image = UIImage(systemName: "paperplane")
        config.background.imageContentMode = .center
        config.imagePlacement = .trailing
        config.imagePadding = 10
        config.title = "送出"

        goButton.tintColor = .white
        goButton.configuration = config
//        goButton.frame = CGRect(x: 64, y: 800, width: width, height: height)
        goButton.backgroundColor = SystemColor.blueColor
        goButton.isUserInteractionEnabled = true
        goButton.layer.cornerRadius = 25
        goButton.clipsToBounds = true
        goButton.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)

        view.addSubview(goButton)

        goButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            goButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Use centerXAnchor instead of centerYAnchor
            goButton.widthAnchor.constraint(equalToConstant: 300), // Set a constant width directly
            goButton.heightAnchor.constraint(equalToConstant: 50) // Set a constant height directly
        ])
    }


    // MARK: - COnfigure UIPickerView
    func configurePickerView(_ : UITextField) {

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

    // MARK: - DatePicker

    func configureDatePicker () {
        datePicker.frame = CGRect(x: 64, y: 570, width: 250, height: 60)
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = .current
        datePicker.timeZone = .gmt
        view.addSubview(datePicker)

//        datePicker.widthAnchor.constraint(equalToConstant: 250).isActive = true
//        datePicker.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    //MARK: - @objc functions.
    @objc func scannerButtonTapped () {
        print("scannerButton tapped")
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: true)
    }

    // UITextField
    @objc func doneClick () {
        pickerViewTextField.resignFirstResponder()
        print("doneClick")
    }

    @objc func cancelClick () {
        pickerViewTextField.resignFirstResponder()
        print("cancelClick")
    }

    @objc func qtyTextFieldTapped () {
        qtyTextField.becomeFirstResponder()
        print("qtyTextField tapped")
    }

    @objc func articleNumberTextFieldTapped () {
        articleNumberTextField.becomeFirstResponder()
        print("qtyTextField tapped")
    }

    // UIButton
    @objc func goButtonTapped () {
        let listVC = ProductListViewController()
        listVC.modalPresentationStyle = .fullScreen
//        present(listVC, animated: true)
        print("goButtonTapped, present to nextPage")
    }

    // UISegmentedControl
    @objc func segmentedControlTapped () {

        switch segmentedControl.selectedSegmentIndex {
            case 0:
                print("Case 0 - 借出")
                dateSelectTitleLabel.text = "填入借出日期:"

            case 1:
                print("Case 1 - 歸還")
                dateSelectTitleLabel.text = "填入歸還日期:"

            case 2:
                print("Case 2 - 其他")
                dateSelectTitleLabel.text = "填入借出日期:"

            default:
                break
        }

    }

    @objc func tapTheView (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        print("tapTheView")
    }

    func hideKeyboard () {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer()
        tap.isEnabled = true
        tap.numberOfTouchesRequired = 1
        tap.addTarget(self, action: #selector(tapTheView))
        view.addGestureRecognizer(tap)
    }

    func checkArticleNumberCorrection () {
        let articleNumber = articleNumberTextField.text ?? ""
        if articleNumber.count == 5 {
            print("Correct numberCount enter")
            articleNumberStatusLabel.isHidden = true
            articleNumberTextField.backgroundColor   = UIColor.systemGray6
            articleNumberTextField.textColor         = UIColor.darkGray
            articleNumberTextField.layer.borderColor = .none
            articleNumberTextField.layer.borderWidth = 0
        } else {
            print("Wrong numberCount enter, It needs adjust.")
            articleNumberStatusLabel.isHidden = false
            articleNumberStatusLabel.text = "請輸入五位數字"
            articleNumberTextField.layer.borderColor  = UIColor.systemRed.cgColor
            articleNumberTextField.layer.borderWidth  = 0.2
            articleNumberTextField.layer.cornerRadius = 3
            articleNumberTextField.backgroundColor    = UIColor(red: 252/255, green: 242/255, blue: 244/255, alpha: 1)
            articleNumberTextField.textColor          = UIColor.systemRed
        }
        print("The articleNumber your entered is \(articleNumber)")
    }

    func checkQtyCorrection () {
        qtyStatusLabel.isHidden = true
        let qtyNumber = qtyTextField.text ?? ""
        if qtyNumber.count > 0 && Int(qtyNumber) != 0 {
            print("\(qtyNumber)")
            qtyStatusLabel.isHidden = true
            qtyTextField.backgroundColor   = UIColor.systemGray6
            qtyTextField.textColor         = UIColor.darkGray
            qtyTextField.layer.borderColor = .none
            qtyTextField.layer.borderWidth = 0
        } else {
            qtyStatusLabel.isHidden = false
            qtyStatusLabel.text = "請輸入數量"
            qtyTextField.layer.borderColor  = UIColor.systemRed.cgColor
            qtyTextField.layer.borderWidth  = 0.2
            qtyTextField.layer.cornerRadius = 3
            qtyTextField.backgroundColor    = UIColor(red: 252/255, green: 242/255, blue: 244/255, alpha: 1)
            qtyTextField.textColor          = UIColor.systemRed
        }
    }
}


// MARK: - Extension for UITextField Delegate
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

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        pickerView.isHidden = false
        print("textFieldDidBeginEditing")
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.configurePickerView(pickerViewTextField)
        print("textFieldDidBeginEditing")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        checkArticleNumberCorrection()
        checkQtyCorrection          ()
        return true
    }
}

// MARK: - Extension for QRCode scanner.
extension HomePageViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let image = scan.imageOfPage(at: scan.pageCount - 1)
            processImage(image: image)
            dismiss(animated: true, completion: nil)
    }

    func processImage(image: UIImage) {
            guard let cgImage = image.cgImage else {
                print("Failed to get cgimage from input image")
                return
            }
            let handler = VNImageRequestHandler(cgImage: cgImage)
            let request = VNDetectBarcodesRequest { request, error in
                if let observation = request.results?.first as? VNBarcodeObservation,
                   observation.symbology == .qr {
                    print(observation.payloadStringValue ?? "")
                }
            }
            do {
                try handler.perform([request])
            } catch {
                print(error)
        }
    }
}
