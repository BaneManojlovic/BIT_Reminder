//
//  PasswordTextField.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 20.9.23..
//

import UIKit

class PasswordTextField: BaseInputTextFieldView {

    // MARK: - Properties

    var iconClick = true

    var rightEyeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        return button
    }()
    lazy var secureTextField: SecureTextField = {
        let textField = SecureTextField()
        textField.layer.masksToBounds = true
        textField.clearsOnBeginEditing = false
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
    override func setup() {
        secureTextField.rightView = self.rightEyeButton
        secureTextField.rightViewMode = .always
        secureTextField.delegate = self
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(secureTextField)
        mainStackView.addArrangedSubview(errorLabel)
        /// set constraints
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            secureTextField.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 0),
            secureTextField.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 0),
            secureTextField.heightAnchor.constraint(equalToConstant: 60),
            secureTextField.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 0),
            rightEyeButton.heightAnchor.constraint(equalToConstant: 40),
            rightEyeButton.widthAnchor.constraint(equalToConstant: 60),
            errorLabel.bottomAnchor.constraint(greaterThanOrEqualTo: mainStackView.bottomAnchor, constant: -5)

            ])
        /// set target for rightEyeButton and textField
        secureTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.rightEyeButton.addTarget(self, action: #selector(toggleButton), for: .touchUpInside)
    }

    @objc override func textFieldDidChange(_ textField: UITextField) {
        let isValid = EmailAndPasswordValidation.isPasswordValid(textField: secureTextField)
        if let text = secureTextField.text {
            if text.isEmpty {
                setUpNoErrorView()
                isError = true
            } else {
                if isValid == false {
                    errorLabel.text = L10n.labelErrorMessagePasswInvalidFormat
                    setUpErrorView()
                    if secureTextField.text?.isEmpty == true {
                        setUpNoErrorView()
                    }
                } else {
                    setUpNoErrorView()
                }
            }
        }
    }

    func setUpErrorView() {
        errorLabel.isHidden = false
        isError = true
        errorLabel.textColor = UIColor.systemRed
        secureTextField.layer.borderWidth = 2
        secureTextField.layer.borderColor = UIColor.systemRed.cgColor
    }

    func setUpNoErrorView() {
        isError = false
        errorLabel.isHidden = true
        secureTextField.layer.borderWidth = 0
    }

    func setupEyeButtonImage(withImage image: UIImage?) {
        rightEyeButton.setImage(image, for: .normal)
        rightEyeButton.imageView?.contentMode = .scaleAspectFit
    }

    @objc func toggleButton() {
        if iconClick == true {
            self.secureTextField.isSecureTextEntry = false
            setupEyeButtonImage(withImage: UIImage(systemName: "eye"))
        } else {
            self.secureTextField.isSecureTextEntry = true
            setupEyeButtonImage(withImage: UIImage(systemName: "eye.slash"))
        }
        iconClick = !iconClick
    }

    override func textFieldDidBeginEditing(_ textField: UITextField) {
        setUpNoErrorView()
    }
    override func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            setUpNoErrorView()
            isError = true
        }
    }
}
