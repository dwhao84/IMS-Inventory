//
//  RackingCalculatorViewController.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/12/27.
//

import UIKit

class RackingCalculatorViewController: UIViewController {
    
    let singleSidePickerView: UIPickerView = UIPickerView()
    let options: [String] = [
        "True", "False"
    ]
    
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
        button.addTarget(self, action: #selector(clearnBtnTapped), for: .touchUpInside)
        button.configurationUpdateHandler = { button in
            button.alpha = button.isHighlighted ? 0.7 : 1.0
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    let nintySecQtyTextField: UITextField = {
        let tf: UITextField = UITextField()
        tf.placeholder = String(localized: "Enter ninty section qty")
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.textColor = Colors.darkGray
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    let sixtySecQtyTextField: UITextField = {
        let tf: UITextField = UITextField()
        tf.placeholder = String(localized: "Enter sixty section qty")
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.textColor = Colors.darkGray
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    let singleSideTextField: UITextField = {
        let tf: UITextField = UITextField()
        tf.placeholder = String(localized: "Is single side or not?")
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.borderStyle = .roundedRect
        tf.textColor = Colors.darkGray
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    public var outputTextView: UITextView = {
        let tv: UITextView = UITextView()
        tv.isSelectable = true
        tv.text = String(localized: "No content has been entered")
        tv.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        tv.textColor = Colors.darkGray
        tv.textAlignment = .left
        tv.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        tv.isScrollEnabled = true
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    } ()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
    
    lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    } ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.overrideUserInterfaceStyle = .light
        setupUI()
    }
    
    private func tapGesture () {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        self.view.addGestureRecognizer(tap)
    }
    
    func setupUI () {
        addConstraints()
        tapGesture()
        addDelegates()
        setToolBar()
        singleSideTextField.inputView = singleSidePickerView
    }
    
    func setToolBar() {
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
        singleSideTextField.inputAccessoryView = toolbar
    }
    
    func addDelegates () {
        nintySecQtyTextField.delegate = self
        sixtySecQtyTextField.delegate = self
        singleSideTextField.delegate = self
        singleSidePickerView.delegate = self
        singleSidePickerView.dataSource = self
    }
    
    func addConstraints() {
       calculationBtn.widthAnchor.constraint(equalToConstant: 200).isActive = true
       
       // Add arranged subviews to stack views
       stackView.addArrangedSubview(nintySecQtyTextField)
       stackView.addArrangedSubview(sixtySecQtyTextField)
       stackView.addArrangedSubview(singleSideTextField)
       buttonsStackView.addArrangedSubview(calculationBtn)
       buttonsStackView.addArrangedSubview(clearBtn)
       
       // Set fixed heights for UI elements
       [nintySecQtyTextField, sixtySecQtyTextField, singleSideTextField, calculationBtn, clearBtn].forEach {
           $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
       }
       outputTextView.heightAnchor.constraint(equalToConstant: 400).isActive = true
       
       // Add subviews
       view.addSubview(scrollView)
       scrollView.addSubview(stackView)
       scrollView.addSubview(buttonsStackView)
       scrollView.addSubview(outputTextView)
       
       // Enable translatesAutoresizingMaskIntoConstraints if needed
       [scrollView, stackView, buttonsStackView, outputTextView].forEach {
           $0.translatesAutoresizingMaskIntoConstraints = false
       }

       NSLayoutConstraint.activate([
           // ScrollView constraints
           scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
           scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
           scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
           
           // StackView constraints
           stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
           stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
           stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
           stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
           
           // ButtonsStackView constraints
           buttonsStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
           buttonsStackView.widthAnchor.constraint(equalToConstant: 300),
           buttonsStackView.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor),
           
           // OutputTextView constraints
           outputTextView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 20),
           outputTextView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
           outputTextView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
           outputTextView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20)
       ])
    }
    
    // MARK: - Actions:
    @objc func calculationBtnTapped(_ sender: UIButton) {
        print("=== calculation Btn Tapped ===")
        
        guard let nintyText = nintySecQtyTextField.text,
              let sixtyText = sixtySecQtyTextField.text,
              let nintySecQty = Int(nintyText),
              let sixtySecQty = Int(sixtyText) 
        else {
            AlertManager.showButtonAlert(on: self,
            title: "Error", message: "Invalid Input")
            return
        }
        
        let isSingleSide = singleSideTextField.text == "True"
        calculateRacking(nintySecQty, sixtySecQty, isSingleSide: isSingleSide)
        print("=== calculation is Active ===")
    }
    
    @objc func clearnBtnTapped(_ sender: UIButton) {
        print("=== clearn Btn Tapped ===")
        [nintySecQtyTextField, sixtySecQtyTextField, singleSideTextField,].forEach {
            $0.text = ""
        }
        outputTextView.text = ""
    }
    
    @objc func dismissPicker () {
        print("=== dismissPicker ===")
        self.view.endEditing(true)
    }
}


// MARK: -  Racking Calculator
extension RackingCalculatorViewController {
    public enum uprightHeight: Int {
        case nintySec = 90
        case sixtySec = 60
    }
    
    func calculateRacking(_ nintySecQty: Int, _ sixtySecQty: Int, isSingleSide: Bool = true) {
        let additionalLength: Int = 0
        var output = ""
        
        // Calculate floor rail length
        let floorFullLength = (uprightHeight.nintySec.rawValue * nintySecQty + uprightHeight.sixtySec.rawValue * sixtySecQty + additionalLength)
        output += "The whole section is \(floorFullLength) cm\n\n"
        
        let divideNumbers = (floorFullLength / 197)
        let afterDivideNum = (floorFullLength % 197)
        
        if floorFullLength < 197 {
            output += "\(floorFullLength)cm * 1\n"
            output += "The 90's section is \(nintySecQty), the 60's section is \(sixtySecQty) sections\n\n"
        } else {
            output += "197cm * \(divideNumbers) + \(afterDivideNum)cm * 1\n"
            output += "The 90's section is \(nintySecQty), the 60's section is \(sixtySecQty) sections\n\n"
        }
        
        // Calculate accessories
        let postOfUprightQty = (nintySecQty + sixtySecQty) + 1
        output += "15525 * \(postOfUprightQty)\n"
        output += "50033 * \(postOfUprightQty)\n"
        output += "14011 * \(postOfUprightQty)\n\n"
        
        if nintySecQty == 0 {
            output += "19441 * \(nintySecQty)\n"
            output += "10646 * \(sixtySecQty)\n"
        } else if sixtySecQty == 0 {
            output += "17696 * \(nintySecQty)\n"
            output += "10647 * \(nintySecQty)\n"
        } else {
            output += "17696 * \(nintySecQty)\n"
            output += "10647 * \(nintySecQty)\n"
            output += "19441 * \(nintySecQty)\n"
            output += "10646 * \(sixtySecQty)\n"
        }
        
        let bracketForBackPanelHolderMiddleQty = (nintySecQty + sixtySecQty) * 2
        output += "\n10637 * \(bracketForBackPanelHolderMiddleQty)\n\n"
        
        if isSingleSide && nintySecQty == 0 {
            if sixtySecQty >= 2 {
                output += "21963 * \(sixtySecQty - 1)\n"
                output += "10648 * 2\n"
                output += "10600 * \(sixtySecQty)\n\n"
            } else {
                output += "10648 * \(sixtySecQty * 2)\n\n"
            }
            
            output += "10641 * \(sixtySecQty)\n"
            output += "10639 * \(sixtySecQty)\n"
            
        } else if isSingleSide && sixtySecQty == 0 {
            if nintySecQty >= 2 {
                output += "21962 * \(nintySecQty - 1)\n"
                output += "10664 * 2\n"
                output += "10600 * \(nintySecQty)\n\n"
            } else {
                output += "10664 * \(nintySecQty * 2)\n\n"
            }
            
            output += "10642 * \(nintySecQty)\n"
            output += "10640 * \(nintySecQty)\n"
            
        } else if !isSingleSide && sixtySecQty == 0 {
            if nintySecQty >= 2 {
                output += "21962 * \(nintySecQty - 1)\n"
                output += "10664 * 2\n"
                output += "10600 * \(nintySecQty)\n\n"
            } else {
                output += "10664 * \(nintySecQty * 2)\n\n"
            }
            
            output += "10642 * \(nintySecQty * 1)\n"
            output += "10640 * \(nintySecQty * 1)\n"
            
        } else if !isSingleSide && nintySecQty == 0 {
            if sixtySecQty >= 2 {
                output += "21963 * \(sixtySecQty - 1)\n"
                output += "10648 * 2\n"
                output += "10600 * \(sixtySecQty)\n\n"
            } else {
                output += "10648 * \(sixtySecQty * 2)\n\n"
            }
            
            output += "10641 * \(sixtySecQty * 2)\n"
            output += "10639 * \(sixtySecQty * 2)\n"
            
        } else {
            output += "10642 * \(nintySecQty * 1)\n"
            output += "10640 * \(nintySecQty * 1)\n"
            output += "10641 * \(sixtySecQty * 1)\n"
            output += "10639 * \(sixtySecQty * 1)\n"
            output += "21962, 21963, 10664, 10648 need to calculate by yourself!!!\n"
        }
        
        output += "\n80080 * \(Int(floorFullLength/197)) + \(floorFullLength % 197)cm * 1"
        outputTextView.text = output
    }
}

// MARK: - UITextFieldDelegate
extension RackingCalculatorViewController: UITextFieldDelegate {
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
        textField.resignFirstResponder()
        return true
    }
}

extension RackingCalculatorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count  // renamed from isTrue to options
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        singleSideTextField.text = options[row]
        print(singleSideTextField.text ?? "No Content")// renamed from 'is' to selectedLabel and using selected row
        singleSidePickerView.reloadAllComponents()
    }
}

#Preview {
    UINavigationController(rootViewController: RackingCalculatorViewController())
}
