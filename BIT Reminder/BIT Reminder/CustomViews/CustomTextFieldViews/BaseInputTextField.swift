//
//  BaseInputTextField.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 16.1.24..
//

import UIKit

class BaseInputTextFieldView: UIView {
    
    var isError: Bool = true

    var mainStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var inputTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.layer.masksToBounds = true
        textField.clearsOnBeginEditing = false
        return textField
    }()

    lazy var errorLabel: ErrorLabel = {
        let errorLabel = ErrorLabel()
        errorLabel.isHidden = true
        return errorLabel
    }()
    override func awakeFromNib() {
        setup()
    }

    // MARK: - Initialization via code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    // MARK: - Initialization via Storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    func setup() {
        self.backgroundColor = .clear
        addSubview(mainStackView)
        inputTextField.isEnabled = true
        inputTextField.delegate = self
        mainStackView.addArrangedSubview(inputTextField)
        mainStackView.addArrangedSubview(errorLabel)
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            inputTextField.heightAnchor.constraint(equalToConstant: 60),
            errorLabel.bottomAnchor.constraint(greaterThanOrEqualTo: mainStackView.bottomAnchor, constant: -7)
        ])
        inputTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

}

extension BaseInputTextFieldView: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
