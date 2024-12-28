//
//  ShelvingSystemViewController.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/12/13.
//

import UIKit

class ShelvingSystemViewController: UIViewController {
    let shelvingHeight: [String] = ["854", "1304", "2480"]
    let withBase : [String] = [String(localized: "True"), String(localized: "False")] // 記得加多國語係
    
    let shelvingHeightPickerView: UIPickerView = UIPickerView()
    let withBaseOrNotPickerView: UIPickerView = UIPickerView()
    
    enum Section: String {
        case ninty = "ninty"
        case sixty = "sixty"
    }
    
    enum ShelvingSystemHeight: String {
        case height854  = "854"
        case height1304 = "1304"
        case height2480 = "2480"
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
        button.addTarget(self, action: #selector(clearBtnTapped), for: .touchUpInside)
        button.configurationUpdateHandler = { button in
            button.alpha = button.isHighlighted ? 0.7 : 1.0
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    let sixtySectionTextField: UITextField = {
        let tf: UITextField = UITextField()
        tf.placeholder = String(localized: "How many 60's section")  // 要加多國語系
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.keyboardType = .numberPad
        tf.clearButtonMode = .whileEditing
        tf.borderStyle = .roundedRect
        tf.textColor = Colors.darkGray
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    let nintySectionTextField: UITextField = {
        let tf: UITextField = UITextField()
        tf.placeholder = String(localized: "How many 90's section") // 要加多國語系
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.keyboardType = .numberPad
        tf.clearButtonMode = .whileEditing
        tf.borderStyle = .roundedRect
        tf.textColor = Colors.darkGray
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    let shelvingHeightTextField: UITextField = {
        let tf: UITextField = UITextField()
        tf.placeholder = String(localized: "Choose your height") // 要加多國語系
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.clearButtonMode = .whileEditing
        tf.borderStyle = .roundedRect
        tf.textColor = Colors.darkGray
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    } ()
    
    let qtyTextField: UITextField = {
        let tf: UITextField = UITextField()
        tf.placeholder = String(localized: "Enter your Qty") // 要加多國語系
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
        tv.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        tv.textColor = Colors.darkGray
        tv.textAlignment = .left
        tv.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        tv.isScrollEnabled = true
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Switching Shelving System VC")
        
        setupUI()
    }
    
    private func setupOutputTextView () {
        outputTextView.textAlignment = .left
        outputTextView.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    func setupUI () {
        self.view.overrideUserInterfaceStyle = .light
        configStackView()
        addConstraints()
        addDelegates()
        setupPickerViews()
        setToolBar()
    }
    
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
        shelvingHeightTextField.inputAccessoryView = toolbar
    }
    
    func addDelegates() {
        // Set up delegates
        shelvingHeightPickerView.delegate = self
        shelvingHeightPickerView.dataSource = self
        
        shelvingHeightTextField.delegate = self
        sixtySectionTextField.delegate = self
        nintySectionTextField.delegate = self
        qtyTextField.delegate = self
    }
    
    @objc private func dismissPicker() {
        view.endEditing(true)
    }
    
    func configStackView () {
        stackView.addArrangedSubview(sixtySectionTextField)
        stackView.addArrangedSubview(nintySectionTextField)
        stackView.addArrangedSubview(shelvingHeightTextField)
        stackView.addArrangedSubview(qtyTextField)
        
        buttonsStackView.addArrangedSubview(calculationBtn)
        buttonsStackView.addArrangedSubview(clearBtn)
    }
    
    func setupPickerViews () {
        shelvingHeightTextField.inputView   = shelvingHeightPickerView
    }
    
    func addConstraints() {
        // Set fixed heights for UI elements
        [shelvingHeightTextField, sixtySectionTextField, nintySectionTextField, qtyTextField].forEach {
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        outputTextView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        calculationBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
    
    // MARK: - Actions
    @objc func calculationBtnTapped (_ sender: UIButton) {
        print("calculation Btn Tapped")
        
        guard let nintySectionQty = Int(nintySectionTextField.text!),
              let sixtySectionQty = Int(sixtySectionTextField.text!),
              let height = Int(shelvingHeightTextField.text!),
              let qtyOfShelf = Int(qtyTextField.text!)
        else { print("Missing Content")
            AlertManager.showButtonAlert(on: self, title: String(localized: "Error"), message: String(localized: "Missing Content"))
            return
        }
        setupOutputTextView()
        // MARK: 傳入shelving system的算法
        calculateShelvingSystem(nintySection: nintySectionQty, sixtySection: sixtySectionQty, height: height, qtyOfShelf: qtyOfShelf)
        
    }
    
    @objc func clearBtnTapped (_ sender: UIButton) {
        print("clearButton Tapped")
        [nintySectionTextField, sixtySectionTextField, qtyTextField, shelvingHeightTextField].forEach {
            $0.text = ""
        }
        outputTextView.text = ""
    }
    
}

extension ShelvingSystemViewController: UITextFieldDelegate {
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

extension ShelvingSystemViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case shelvingHeightPickerView:
            return shelvingHeight.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case shelvingHeightPickerView:
            return shelvingHeight[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case shelvingHeightPickerView:
            shelvingHeightTextField.text = shelvingHeight[row]
        default:
            break
        }
    }
}

extension ShelvingSystemViewController {
    public func calculateShelvingSystem(nintySection: Int, sixtySection: Int, height: Int, qtyOfShelf: Int) {
        // 只有 60 sections
        if nintySection == 0 && sixtySection >= 1 {
            outputTextView.text = 
            """
            50167 SHELF PERFORATED METAL F SHELVING SYSTEM D598 W618MM WHI * \(qtyOfShelf)
            50168 SHELF SUPPORT F SHELF PERFORATED METAL F SHELVING SYSTEM L584MM GALV * \(qtyOfShelf * 2 - sixtySection * 2)
            """
            
            switch height {
            case 854:
                outputTextView.text = 
                """
                50216 Left side unit f shelving system D600 H854MM whi * \(sixtySection)
                50217 Middle unit f shelving system D600 H854MM whi * \(sixtySection)
                50218 Right side unit f shelving system D600 H854MM whi * \(sixtySection)
                ===========
                50166 Crossbeam f shelving system L560MM whi * \(sixtySection * 3)
                """
                
            case 1340:
                outputTextView.text = 
                """
                50213 Left side unit f shelving system D600 H1304MM whi * \(sixtySection)
                50214 Middle unit f shelving system D600 H1304MM whi * \(sixtySection)
                50215 Right side unit f shelving system D600 H1304MM whi * \(sixtySection)
                ===========
                50166 Crossbeam f shelving system L560MM whi * \(sixtySection * 3)
                """
            case 2480:
                outputTextView.text = 
                """
                50210 Left side unit f shelving system D600 H2480 whi * \(sixtySection)
                50211 Middle unit f shelving system D600 H2480 whi * \(sixtySection)
                50212 Right side unit f shelving system D600 H2480 whi * \(sixtySection)
                ===========
                50166 Crossbeam f shelving system L560MM whi * \(sixtySection * 3)
                ===========
                50190 Ceiling support 680MM f shelving system whi * 2 \n
                50188 Ceiling support clamp f shelving system whi * 2 \n
                """
                
            default:
                break
            }
        }
        
        // 只有 90 sections
        else if sixtySection == 0 && nintySection >= 1 {
            outputTextView.text =
            """
            50187 SHELF MESH F SHELVING SYSTEM D898 W618MM WHI * \(qtyOfShelf)
            50184 SHELF SUPPORT F SHELVING SYSTEM L884MM WHI * \(qtyOfShelf * 2 - nintySection * 2)
            """
            
            switch height {
            case 854:
                outputTextView.text =
                """
                50216 Left side unit f shelving system D600 H854MM whi * 1
                50217 Middle unit f shelving system D600 H854MM whi * \(nintySection)
                50218 Right side unit f shelving system D600 H854MM whi * 1
                 ===========
                50183 Crossbeam f shelving system L860mm whi * \(nintySection * 3)
                """
                
            case 1340:
                outputTextView.text =
                """
                50213 Left side unit f shelving system D600 H1304MM whi * 1
                50214 Middle unit f shelving system D600 H1304MM whi * \(sixtySection)
                50215 Right side unit f shelving system D600 H1304MM whi * 1
                 ===========
                50166 Crossbeam f shelving system L560MM whi * \(sixtySection * 3)
                """
                
            case 2480:
                outputTextView.text =
                """
                50210 Left side unit f shelving system D600 H2480 whi * 1
                50211 Middle unit f shelving system D600 H2480 whi * \(nintySection)
                50212 Right side unit f shelving system D600 H2480 whi * 1
                 ===========
                50190 Ceiling support 680MM f shelving system whi * 2
                50188 Ceiling support clamp f shelving system whi * 2
                """
                
            default:
                break
            }
        }
        
        // 同時有 90 和 60 sections
        else if nintySection >= 1 && sixtySection >= 1 {
            outputTextView.text =
            """
            50167 SHELF PERFORATED METAL F SHELVING SYSTEM D598 W618MM WHI * \(qtyOfShelf)
            50168 SHELF SUPPORT F SHELF PERFORATED METAL F SHELVING SYSTEM L584MM GALV * \(qtyOfShelf * 2 - sixtySection * 2)
            50187 SHELF MESH F SHELVING SYSTEM D898 W618MM WHI * \(qtyOfShelf)
            50184 SHELF SUPPORT F SHELVING SYSTEM L884MM WHI \(qtyOfShelf * 2 - nintySection * 2)
            """
            
            switch height {
            case 854:
                outputTextView.text =
                """
                50216 Left side unit f shelving system D600 H854MM whi * \(sixtySection)
                50217 Middle unit f shelving system D600 H854MM whi * \(sixtySection)
                50218 Right side unit f shelving system D600 H854MM whi * \(sixtySection)
                 ===========
                50183 Crossbeam f shelving system L860mm whi * \(nintySection * 3)
                50166 Crossbeam f shelving system L560MM whi * \(sixtySection * 3)
                """
                
            case 1340:
                outputTextView.text = """
                50213 Left side unit f shelving system D600 H1304MM whi * \(sixtySection)
                50214 Middle unit f shelving system D600 H1304MM whi * \(sixtySection)
                50215 Right side unit f shelving system D600 H1304MM whi * \(sixtySection)
                ===========
                50183 Crossbeam f shelving system L860mm whi * \(nintySection * 3)
                50166 Crossbeam f shelving system L560MM whi * \(sixtySection * 3)
                """
            case 2480:
                outputTextView.text =
                """
                50210 Left side unit f shelving system D600 H2480 whi * 1
                50211 Middle unit f shelving system D600 H2480 whi * \(sixtySection + nintySection)
                50212 Right side unit f shelving system D600 H2480 whi * 1
                 ===========
                50183 Crossbeam f shelving system L860mm whi * \(nintySection * 3)
                50166 Crossbeam f shelving system L560MM whi * \(sixtySection * 3)
                 ===========
                50190 Ceiling support 680MM f shelving system whi * 2
                50188 Ceiling support clamp f shelving system whi * 2
                """
            default:
                break
            }
        }
    }
}

#Preview {
    UINavigationController(rootViewController: ShelvingSystemViewController())
}
