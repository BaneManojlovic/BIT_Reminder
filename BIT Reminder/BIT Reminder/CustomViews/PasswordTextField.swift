//
//  PasswordTextField.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 20.9.23..
//

import UIKit

class PasswordTextField: UIView {

    // MARK: - Properties

    var iconClick = true
    var showSecureTextEntry = true

    var rightEyeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        return button
    }()

    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = Asset.textfieldBlueColor.color
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.leftViewMode = .always
        textField.layer.masksToBounds = true
        textField.textContentType = .none
        textField.autocorrectionType = .no
        textField.textContentType = .init(rawValue: "")
        textField.isSecureTextEntry = true
        textField.textColor = .white
        textField.layer.cornerRadius = 10
        return textField
    }()

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

    // MARK: - Setup method

    func setup() {
        self.inputTextField.textContentType = .oneTimeCode
        self.inputTextField.textContentType = .init(rawValue: "")
        self.backgroundColor = Asset.textfieldBlueColor.color
        self.layer.cornerRadius = 10
        self.addSubview(inputTextField)
        self.addSubview(rightEyeButton)
        /// set constraints for inputTextField & rightEyeButton
        NSLayoutConstraint.activate([
            inputTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6),
            inputTextField.heightAnchor.constraint(equalToConstant: 50.0),
            inputTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60),
            rightEyeButton.heightAnchor.constraint(equalToConstant: 30),
            rightEyeButton.widthAnchor.constraint(equalToConstant: 30),
            rightEyeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -6),
            rightEyeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)

            ])
        /// set target for rightEyeButton
        self.rightEyeButton.addTarget(self, action: #selector(toggleButton), for: .touchUpInside)
    }

    @objc func toggleButton() {
        if iconClick == true {
            self.inputTextField.isSecureTextEntry = false
            self.rightEyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            self.inputTextField.isSecureTextEntry = true
            self.rightEyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
        iconClick = !iconClick
    }
}
