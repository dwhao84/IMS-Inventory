//
//  BinsViewController.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/12/10.
//

import UIKit

class BinViewController: UIViewController {
    
    let bins: [String] = ["Pallet Bin", "Bins"]
    let palletBinSize: [String] = ["60 * 80", "80 * 120"]
    let binSize: [String] = ["40 * 60", "60 * 80"]
    
    let sizePickerView: UIPickerView = UIPickerView()
    let typePickerView: UIPickerView = UIPickerView()
    
    let calculator = BinCalculator()
    
    enum BinType: String {
        case palletBin = "Pallet Bin"
        case bin = "Bin"
    }
    
    enum PalletBinSize: String {
        case sixtyByEighty = "60 * 80"
        case eightyByOneTwenty = "80 * 120"
    }
    
    enum BinSize: String {
        case fortyBySixty = "40 * 60"
        case sixtyByEighty = "60 * 80"
    }
    
    
    private lazy var calculationBtn: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .customBlack
        config.baseForegroundColor = .customWhite
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: UIColor.customWhite
        ]
        config.attributedTitle = AttributedString(String(localized: "Calculation"), attributes: AttributeContainer(attributes))
        config.cornerStyle = .capsule
        
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(calculationBtnTapped), for: .touchUpInside)
        button.configurationUpdateHandler = { button in
            button.alpha = button.isHighlighted ? 0.7 : 1.0
        }
        return button
    }()
    
    private lazy var clearBtn: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.borderless()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: Colors.lightGray
        ]
        config.attributedTitle = AttributedString(String(localized: "Clear"), attributes: AttributeContainer(attributes))
        config.cornerStyle = .capsule
        button.configuration = config
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        button.configurationUpdateHandler = { button in
            button.alpha = button.isHighlighted ? 0.7 : 1.0
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    let typeOfBinTextField: UITextField = {
        let tf: UITextField = UITextField()
        tf.placeholder = String(localized: "Choose your bins type")
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.borderStyle = .roundedRect
        tf.textColor = Colors.darkGray
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    let  binSizeTextField: UITextField = {
        let tf: UITextField = UITextField()
        tf.placeholder = String(localized: "Choose your bins size")
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.borderStyle = .roundedRect
        tf.textColor = Colors.darkGray
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    let  qtyTextField: UITextField = {
        let tf: UITextField = UITextField()
        tf.placeholder = String(localized: "Enter your Qty")
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.textColor = Colors.darkGray
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    let stackView: UIStackView = {
        let sv: UIStackView = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 20
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    } ()
    
    let buttonsStackView: UIStackView = {
        let sv: UIStackView = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 20
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    } ()
    
    public var outputTextView: UITextView = {
        let tv: UITextView = UITextView()
        tv.isSelectable = true
        tv.text = String(localized: "No content has been entered") // 還沒加上多國語系
        tv.font = .systemFont(ofSize: 23, weight: .bold)
        tv.textColor = Colors.darkGray
        tv.textAlignment = .center
        tv.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        tv.isScrollEnabled = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Switching Bin VC")
        
        setupUI()
    }
    
    private func setupOutputTextView () {
        outputTextView.textAlignment = .left
        outputTextView.font = .systemFont(ofSize: 12, weight: .regular)
    }
    
    // MARK: - Set up UI
    func setupUI () {
        self.view.overrideUserInterfaceStyle = .light
        configStackView()
        configButtonsStackView()
        addConstraints()
        addDelegates()
        setupPickerViews()
    }
    
    // MARK: - Add Delegatea
    func addDelegates() {
        // Set up delegates
        sizePickerView.delegate = self
        typePickerView.delegate = self
        binSizeTextField.delegate = self
        typeOfBinTextField.delegate = self
        
        // Connect picker views to text fields
        typeOfBinTextField.inputAccessoryView = typePickerView
        binSizeTextField.inputAccessoryView = sizePickerView
        
        // Create and configure toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissPicker)
        )
        
        let cancelButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissPicker)
        )
        
        toolbar.setItems([cancelButton, doneButton], animated: false)
        // Add toolbar as input accessory view
        binSizeTextField.inputAccessoryView   = toolbar
        typeOfBinTextField.inputAccessoryView = toolbar
    }
    
    // MARK: - Set up StackView
    func configStackView () {
        stackView.addArrangedSubview(typeOfBinTextField)
        stackView.addArrangedSubview(binSizeTextField)
        stackView.addArrangedSubview(qtyTextField)
    }
    
    // MARK: - Set up Button StackView
    func configButtonsStackView () {
        buttonsStackView.addArrangedSubview(calculationBtn)
        buttonsStackView.addArrangedSubview(clearBtn)
    }
    
    // MARK: - Set up PickerView
    func setupPickerViews () {
        typeOfBinTextField.inputAccessoryView = typePickerView
        binSizeTextField.inputAccessoryView   = sizePickerView
    }
    
    // MARK: - Add Constraints
    func addConstraints () {
        [ binSizeTextField, typeOfBinTextField, qtyTextField].forEach {
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        outputTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        [calculationBtn, clearBtn].forEach {
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        view.addSubview(stackView)
        view.addSubview(buttonsStackView)
        view.addSubview(outputTextView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            buttonsStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            buttonsStackView.widthAnchor.constraint(equalToConstant: 300),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            outputTextView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 20),
            outputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            outputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // MARK: - Actions
    @objc func calculationBtnTapped (_ sender: UIButton) {
        print("calculation Btn Tapped")
        setupOutputTextView()
        
        
    }
    
    @objc func clearButtonTapped(_ sender: UIButton) {
        print("clearButtonTapped")
        [binSizeTextField, typeOfBinTextField, qtyTextField].forEach {
            $0.text = ""
        }
        outputTextView.text = String(localized: "No content has been entered")
    }
    
    @objc private func dismissPicker() {
        view.endEditing(true)
    }
}

    // MARK: - 計算函數

extension BinViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("textField Should Clear")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textField Did Begin Editing")
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textField Should Begin Editing")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textField Should Return")
        return true
    }
}

extension BinViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // 計算屬性來獲取當前應該顯示的size array
    private var currentSizeArray: [String] {
        return typeOfBinTextField.text == "Bins" ? binSize : palletBinSize
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case sizePickerView:
            return currentSizeArray.count
        case typePickerView:
            return bins.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case sizePickerView:
            return currentSizeArray[row]
        case typePickerView:
            return bins[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case sizePickerView:
            binSizeTextField.text = currentSizeArray[row]
        case typePickerView:
            typeOfBinTextField.text = bins[row]
            sizePickerView.reloadAllComponents()
            binSizeTextField.text = currentSizeArray[0]  // 設置默認值
        default:
            break
        }
    }
}

#Preview {
    UINavigationController(rootViewController: BinViewController())
}
