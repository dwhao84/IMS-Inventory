//
//  BinsViewController.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/12/10.
//

import UIKit

class BinsViewController: UIViewController {
    
    let bins: [String] = ["Pallet Bin", "Bins"]
    let palletBinSize: [String] = ["60 * 80", "80 * 120"]
    let binSize: [String] = ["40 * 60", "60 * 80"]
    
    let sizePickerView: UIPickerView = UIPickerView()
    let typePickerView: UIPickerView = UIPickerView()
    
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
    
    let stackView: UIStackView = {
        let sv: UIStackView = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 20
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    } ()
    
    let textView: UITextView = {
        let tv: UITextView = UITextView()
        tv.text = "xxx"
        tv.isSelectable = true
        tv.textColor = Colors.darkGray
        tv.font = UIFont.systemFont(ofSize: 23)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Switching Bin VC")
        
        setupUI()
    }
    
    func setupUI () {
        self.view.overrideUserInterfaceStyle = .light
        configStackView()
        addConstraints()
        addDelegates()
        setupPickerViews()
    }
    
    func addDelegates () {
        sizePickerView.delegate = self
        typePickerView.delegate = self
        binSizeTextField.delegate = self
        typeOfBinTextField.delegate = self
        
        typeOfBinTextField.inputAccessoryView = typePickerView
        binSizeTextField.inputAccessoryView = sizePickerView
        
        // Optional: Add toolbar as input accessory view
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPicker))
        toolbar.setItems([doneButton], animated: false)
        
        binSizeTextField.inputAccessoryView = toolbar
        typeOfBinTextField.inputAccessoryView = toolbar
    }
    
    @objc private func dismissPicker() {
        view.endEditing(true)
    }
    
    func configStackView () {
        stackView.addArrangedSubview(typeOfBinTextField)
        stackView.addArrangedSubview(binSizeTextField)
        stackView.addArrangedSubview(calculationBtn)
        stackView.addArrangedSubview(textView)
    }
    
    func setupPickerViews () {
        typeOfBinTextField.inputAccessoryView = typePickerView
        binSizeTextField.inputAccessoryView   = sizePickerView
    }
    
    func addConstraints () {
        [ binSizeTextField, typeOfBinTextField].forEach {
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        textView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        calculationBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
    
    @objc func calculationBtnTapped(_ sender: UIButton) {
        print("calculation Btn Tapped")
        
        guard let selectedType = typeOfBinTextField.text,
              let selectedSize = binSizeTextField.text else {
            // Show alert for invalid input
            AlertManager.showButtonAlert(on: self, title: String(localized: "Error"), message: String(localized:"Please select both Bin type and size"))
            return
        }
        
        switch selectedType {
        case "Pallet Bin":
            switch selectedSize {
            case "60 * 80":
                calculatePalletBins(qtyOfPalletBin_sixty_By_Eighty: 1, qtyOfPalletBin_Eighty_By_OneHundredTwenty: 1)
            case "80 * 120":
                calculatePalletBins(qtyOfPalletBin_sixty_By_Eighty: 1, qtyOfPalletBin_Eighty_By_OneHundredTwenty: 1)
                
            default:
                AlertManager.showButtonAlert(on: self, title: String(localized: "Error"), message: String(localized: "Invalid size selection for Pallet Bin"))
            }
            
        case "Bins":
            switch selectedSize {
            case "40 * 60":
                // Handle regular Bins 40*60 calculation
                calculateStandardBins(qtyOfBin_forty_By_Sixty: 1, qtyOfBinSixty_By_Eighty: 1)
            case "60 * 80":
                // Handle regular Bins 60*80 calculation
                calculateStandardBins(qtyOfBin_forty_By_Sixty: 1, qtyOfBinSixty_By_Eighty: 1)
                
            default:
                AlertManager.showButtonAlert(on: self, title: String(localized: "Error"), message: String(localized: "Invalid size selection for Bins"))
            }
            
        default:
            AlertManager.showButtonAlert(on: self, title: String(localized: "Error"), message: String(localized: "Please select a valid Bin type"))
        }
    }
}

extension BinsViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("textField Should Clear")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textField Did Begin Editing")
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension BinsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    UINavigationController(rootViewController: BinsViewController())
}
