//
//  BinsViewController.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/12/10.
//

import UIKit

class BinViewController: UIViewController {
    
    let typeOfBins: [String] = ["Pallet Bin", "Bins"]
    let sizeOfPalletBin: [String] = ["60 * 80", "80 * 120"]
    let sizeOfBins: [String] = ["40 * 60", "60 * 80", "40 * 60 & 60 * 80"]
    
    let sizePickerView: UIPickerView = UIPickerView()
    let typePickerView: UIPickerView = UIPickerView()
    let binsPickerView: UIPickerView = UIPickerView()
    
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
        let btn = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Colors.black
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .light),
            .foregroundColor: Colors.black
        ]
        config.attributedTitle = AttributedString(String(localized: "Clear"), attributes: AttributeContainer(attributes))
        config.cornerStyle = .capsule
        config.background.strokeColor = Colors.black
        btn.configuration = config
        btn.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.configurationUpdateHandler = { btn in
            btn.alpha = btn.isHighlighted ? 0.5 : 1
            btn.configuration = config
        }
        return btn
    }()
    
    let typeOfBinTextField: UITextField = {
        let tf: UITextField = UITextField()
        tf.placeholder = String(localized: "Choose your bins type")
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.borderStyle = .roundedRect
        tf.textColor = Colors.darkGray
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    let binSizeTextField: UITextField = {
        let tf: UITextField = UITextField()
        tf.placeholder = String(localized: "Choose your bins size") // Add localization
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.borderStyle = .roundedRect
        tf.textColor = Colors.darkGray
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    let qtyTextField: UITextField = {
        let tf: UITextField = UITextField()
        tf.placeholder = String(localized: "Enter your Qty")
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.textColor = Colors.darkGray
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    // MARK: - 當選擇多個尺寸的時候，顯示這個textField
    let  secQtyTextField: UITextField = {
        let tf: UITextField = UITextField()
        tf.placeholder = String(localized: "Enter your 40 * 60 Qty") // Add localization
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
        tv.text = String(localized: "No content has been entered")
        tv.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        tv.textColor = Colors.darkGray
        tv.textAlignment = .left
        tv.adjustsFontForContentSizeCategory = true
        tv.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    } ()
    
    lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    } ()
    
    // MARK: - Life Cycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Switching Bin VC")
        
        setupUI()
    }
    
    private func setupOutputTextView () {
        outputTextView.textAlignment = .left
    }
    
    private func tapGesture () {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        self.view.addGestureRecognizer(tap)
    }
    
    // MARK: - Set up UI
    func setupUI () {
        secQtyTextField.isHidden = true
        self.view.overrideUserInterfaceStyle = .light
        configStackView()
        configButtonsStackView()
        addConstraints()
        addDelegates()
        setupPickerViews()
        tapGesture()
        setToolBar()
    }
    
    // MARK: - Add Delegatea
    fileprivate func setToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissPicker)
        )
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        // Add toolbar as input accessory view
        binSizeTextField.inputAccessoryView   = toolbar
        typeOfBinTextField.inputAccessoryView = toolbar
        typeOfBinTextField.inputAccessoryView = toolbar
    }
    
    func addDelegates() {
        // Set up delegates
        sizePickerView.delegate = self
        sizePickerView.dataSource = self
        typePickerView.delegate = self
        typePickerView.dataSource = self
        
        binSizeTextField.delegate = self
        typeOfBinTextField.delegate = self
        secQtyTextField.delegate = self
        qtyTextField.delegate = self
        
        // Connect picker views to text fields
        typeOfBinTextField.inputView = typePickerView
        binSizeTextField.inputView = sizePickerView
    }
    
    // MARK: - Set up StackView
    func configStackView () {
        stackView.addArrangedSubview(typeOfBinTextField)
        stackView.addArrangedSubview(binSizeTextField)
        stackView.addArrangedSubview(qtyTextField)
        stackView.addArrangedSubview(secQtyTextField)
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
    func addConstraints() {
        // Set fixed heights for text fields and buttons
        [binSizeTextField, typeOfBinTextField, qtyTextField, secQtyTextField].forEach {
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        outputTextView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        [calculationBtn, clearBtn].forEach {
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        // Add scrollView
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(buttonsStackView)
        scrollView.addSubview(outputTextView)
        
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content constraints
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            
            buttonsStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            buttonsStackView.widthAnchor.constraint(equalToConstant: 300),
            buttonsStackView.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor),
            
            outputTextView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 20),
            outputTextView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 10),
            outputTextView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -10),
            outputTextView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // **MARK: - Actions**
    @objc func calculationBtnTapped(_ sender: UIButton) {
        print("calculation Btn Tapped")
        
        // 先驗證輸入
        guard let typeOfBin = typeOfBinTextField.text,
              let binSize = binSizeTextField.text,
              let qtyText = qtyTextField.text,
              !typeOfBin.isEmpty,
              !binSize.isEmpty,
              !qtyText.isEmpty,
              let qtyOne = Int(qtyText) else {
            AlertManager.showButtonAlert(on: self,
                                         title: String(localized: "Error"),
                                         message: String(localized: "Missing Content"))
            return
        }
        
        setupOutputTextView()
        
        // 處理標準箱(Bins)的情況
        if typeOfBin == "Bins" {
            switch binSize {
            case sizeOfBins[0]: // 40x60
                calculateStandardBins(binCount40x60: qtyOne, binCount60x80: 0)
                
            case sizeOfBins[1]: // 60x80
                calculateStandardBins(binCount40x60: 0, binCount60x80: qtyOne)
                
            case sizeOfBins[2]: // 兩種尺寸都有
                guard let secQtyText = secQtyTextField.text,
                      !secQtyText.isEmpty,
                      let qtyTwo = Int(secQtyText) else {
                    AlertManager.showButtonAlert(on: self,
                                                 title: String(localized: "Error"),
                                                 message: String(localized: "Missing Second Quantity"))
                    return
                }
                calculateStandardBins(binCount40x60: qtyOne, binCount60x80: qtyTwo)
                
            default:
                AlertManager.showButtonAlert(on: self,
                                             title: String(localized: "Error"),
                                             message: String(localized: "Invalid Bin Size"))
            }
        }
        // 處理托盤箱(Pallet)的情況
        else if typeOfBin == typeOfBins[0] {
            switch binSize {
            case sizeOfBins[0]: // 60x80
                calculatePalletBins(palletCount60x80: qtyOne,
                                    palletCount80x120: 0)
                
            case sizeOfBins[1]: // 80x120
                calculatePalletBins(palletCount60x80: 0,
                                    palletCount80x120: qtyOne)
                
            default:
                AlertManager.showButtonAlert(on: self,
                                             title: String(localized: "Error"),
                                             message: String(localized: "Invalid Pallet Size"))
            }
        }
        else {
            AlertManager.showButtonAlert(on: self,
                                         title: String(localized: "Error"),
                                         message: String(localized: "Invalid Bin Type"))
        }
    }
    
    @objc func clearButtonTapped(_ sender: UIButton) {
        print("DEBUG PRINT: clearButtonTapped")
        [binSizeTextField, typeOfBinTextField, qtyTextField, secQtyTextField].forEach {
            $0.text = ""
        }
        outputTextView.text = ""
        secQtyTextField.isHidden = true
        qtyTextField.placeholder = String(localized: "Enter your Qty")
    }
    
    @objc func dismissPicker(_ sender: UITapGestureRecognizer) {
        print("DEBUG PRINT: dismiss Picker")
        self.view.endEditing(true)
    }
}

// MARK: - 計算函數
extension BinViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("textField Should Clear")
        textField.resignFirstResponder()
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
        return typeOfBinTextField.text == "Bins" ? sizeOfBins : sizeOfPalletBin
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
            return typeOfBins.count
        case binsPickerView:
            return sizeOfBins.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case sizePickerView:
            return currentSizeArray[row]
        case typePickerView:
            return typeOfBins[row]
        case binsPickerView:
            return sizeOfBins[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case sizePickerView:
            binSizeTextField.text = currentSizeArray[row]
            // 檢查是否選擇了 "40 * 60 & 60 * 80"
            if currentSizeArray[row] == "40 * 60 & 60 * 80" {
                secQtyTextField.isHidden = false
                qtyTextField.placeholder    = String(localized: "Choose 40 * 60 of Qty")
                secQtyTextField.placeholder = String(localized: "Choose 60 * 80 of Qty")
            } else {
                secQtyTextField.isHidden = true
            }
            sizePickerView.reloadAllComponents()
            
        case typePickerView:
            binSizeTextField.text = currentSizeArray[0]
            typeOfBinTextField.text = typeOfBins[row]
            // 重置 secQtyTextField 的顯示狀態
            secQtyTextField.isHidden = true
            sizePickerView.reloadAllComponents()
            
        case binsPickerView:
            secQtyTextField.text = sizeOfBins[0]
            secQtyTextField.text = sizeOfBins[row]
            sizePickerView.reloadAllComponents()
            
        default:
            break
        }
    }
}

#Preview {
    UINavigationController(rootViewController: BinViewController())
}

// MARK: - Extension for Bin View Controller
extension BinViewController {
    // Function for calculating standard bins
    public func calculateStandardBins(binCount40x60: Int, binCount60x80: Int) {
        if binCount40x60 > 0 && binCount60x80 > 0 {
            outputTextView.text =
            """
            12483 CORNER POST F BIN H850MM WHI * \(binCount40x60 * 4 + binCount60x80 * 4)\n
            17740 SIDE F BIN L400 H700MM WHI * \(binCount40x60 * 2)\n
            17739 SIDE F BIN L60 H700MM WHI * \(binCount40x60 * 2 + binCount60x80 * 2)\n
            17743 SIDE F BIN L800 H700MM WHI * \(binCount60x80 * 2)\n
            17741 BOTTOM F BIN L600 W400MM WHI \(binCount40x60 * 1)\n
            17744 BOTTOM F BIN L800 W600MM WHI \(binCount60x80 * 1)\n
            """
        } else if binCount40x60 > 0 && binCount60x80 == 0 {
            outputTextView.text =
            """
            12483 CORNER POST F BIN H850MM WHI * \(binCount40x60 * 4)\n
            17740 SIDE F BIN L400 H700MM WHI * \(binCount40x60 * 2)\n
            17739 SIDE F BIN L600 H700MM WHI * \(binCount40x60 * 2)\n
            17741 BOTTOM F BIN L600 W400MM WHI \(binCount40x60 * 1)\n
            """
        } else if binCount40x60 == 0 && binCount60x80 > 0 {
            outputTextView.text =
            """
            12483 CORNER POST F BIN H850MM WHI * \(binCount60x80 * 4)\n
            17739 SIDE F BIN L600 H700MM WHI * \(binCount60x80 * 2)\n
            17743 SIDE F BIN L800 H700MM WHI * \(binCount60x80 * 2)\n
            17744 BOTTOM F BIN L800 W600MM WHI *\(binCount60x80 * 1)
            """
        }
    }
    
    // Function for calculating pallet bins
    public func calculatePalletBins(palletCount60x80: Int, palletCount80x120: Int) {
        if palletCount60x80 > 0 && palletCount80x120 > 0 {
            outputTextView.text = "12482 BIN F HALF PALLET L600 W800 H760MM WHI *  \(palletCount60x80)\n12484 BIN F PALLET L1200 W800 H760MMWHI *  \(palletCount80x120)"
        } else if palletCount60x80 > 0 && palletCount80x120 == 0 {
            outputTextView.text = "12482 BIN F HALF PALLET L600 W800 H760MM WHI * \(palletCount60x80)"
        } else if palletCount60x80 == 0 && palletCount80x120 > 0 {
            outputTextView.text = "12484 BIN F PALLET L1200 W800 H760MMWHI * \(palletCount80x120)"
        }
    }
}
