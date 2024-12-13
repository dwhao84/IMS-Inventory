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
    
    private let calculator: BinCalculatable = BinCalculator()
    
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
    
    public var outputTextView: UITextView = {
        let tv: UITextView = UITextView()
        tv.isSelectable = true
        tv.text = String(localized: "尚未輸入任何內容") // 還沒加上多國語系
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
    
    func setupUI () {
        self.view.overrideUserInterfaceStyle = .light
        configStackView()
        addConstraints()
        addDelegates()
        setupPickerViews()
    }
    
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
        binSizeTextField.inputAccessoryView = toolbar
        typeOfBinTextField.inputAccessoryView = toolbar
    }
    
    @objc private func dismissPicker() {
        view.endEditing(true)
    }
    
    func configStackView () {
        stackView.addArrangedSubview(typeOfBinTextField)
        stackView.addArrangedSubview(binSizeTextField)
        stackView.addArrangedSubview(qtyTextField)
        stackView.addArrangedSubview(calculationBtn)
        stackView.addArrangedSubview(outputTextView)
    }
    
    func setupPickerViews () {
        typeOfBinTextField.inputAccessoryView = typePickerView
        binSizeTextField.inputAccessoryView   = sizePickerView
    }
    
    func addConstraints () {
        [ binSizeTextField, typeOfBinTextField, qtyTextField].forEach {
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        outputTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        calculationBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
    
    @IBAction func calculationBtnTapped(_ sender: UIButton) {
        print("calculation Btn Tapped")
        
        setupOutputTextView()
        
        guard let selectedType = typeOfBinTextField.text,
              let selectedSize = binSizeTextField.text,
              let qtyText = qtyTextField.text,
              let qty = Int(qtyText) else {
            AlertManager.showButtonAlert(on: self,
                                      title: String(localized: "Error"),
                                      message: String(localized:"Please select both Bin type and size"))
            return
        }
        
        let result: BinCalculationResult
        
        switch selectedType {
        case "Pallet Bin":
            switch selectedSize {
            case "60 * 80":
                result = calculator.calculatePalletBins(qtyOfPalletBin_sixty_By_Eighty: qty,
                                                      qtyOfPalletBin_Eighty_By_OneHundredTwenty: 0)
            case "80 * 120":
                result = calculator.calculatePalletBins(qtyOfPalletBin_sixty_By_Eighty: 0,
                                                      qtyOfPalletBin_Eighty_By_OneHundredTwenty: qty)
            default:
                AlertManager.showButtonAlert(on: self,
                                          title: String(localized: "Error"),
                                          message: String(localized: "Invalid size selection for Pallet Bin"))
                return
            }
            
        case "Bins":
            switch selectedSize {
            case "40 * 60":
                result = calculator.calculateStandardBins(qtyOfBin_forty_By_Sixty: qty,
                                                        qtyOfBinSixty_By_Eighty: 0)
            case "60 * 80":
                result = calculator.calculateStandardBins(qtyOfBin_forty_By_Sixty: 0,
                                                        qtyOfBinSixty_By_Eighty: qty)
            default:
                AlertManager.showButtonAlert(on: self,
                                          title: String(localized: "Error"),
                                          message: String(localized: "Invalid size selection for Bins"))
                return
            }
            
        default:
            AlertManager.showButtonAlert(on: self,
                                      title: String(localized: "Error"),
                                      message: String(localized: "Please select a valid Bin type"))
            return
        }
        
        displayCalculationResult(result)
    }
    
    private func displayCalculationResult(_ result: BinCalculationResult) {
        var displayText = "\n"
        for component in result.components {
            displayText += "\(component.partNumber) \(component.description) * \(component.quantity)\n"
        }
        outputTextView.text = displayText
    }
}

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
