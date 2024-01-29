//
//  RegisterView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 8.9.23..
//

import UIKit
import IQKeyboardManager

class RegistrationView: IQPreviousNextView, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var userNameTextField: NameTextFieldView!
    @IBOutlet weak var emailTextField: EmailInputTextFieldView!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var repeatPasswordTextField: PasswordTextField!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Setup methods
    
    func setupUI() {
        self.backgroundColor = Asset.backgroundBlueColor.color
        self.setupLabels()
        self.setupTextFields()
        self.setupButtons()
        self.setupDelegates()
    }
    // MARK: - Private Setup Methods
    
    private func setupLabels() {
        self.screenTitleLabel.text = L10n.titleLabelRegister
        self.screenTitleLabel.textColor = .white
        self.screenTitleLabel.textAlignment = .center
        self.screenTitleLabel.font = UIFont.systemFont(ofSize: 48)
    }
    
    private func setupTextFields() {
        /// userName TextField
        self.userNameTextField.inputTextField.tag = 1
        self.userNameTextField.inputTextField.font = UIFont.systemFont(ofSize: 20)
        self.userNameTextField.layer.cornerRadius = 10
        self.userNameTextField.backgroundColor = .clear
        self.userNameTextField.inputTextField.placeholder = L10n.labelUserName
        /// email TextField
        self.emailTextField.inputTextField.tag = 2
        self.emailTextField.inputTextField.font = UIFont.systemFont(ofSize: 20)
        self.emailTextField.backgroundColor = .clear
        self.emailTextField.layer.cornerRadius = 10
        self.emailTextField.inputTextField.placeholder = L10n.labelEmail
        /// password TextField
        self.passwordTextField.secureTextField.tag = 3
        self.passwordTextField.inputTextField.textContentType = .newPassword
        self.passwordTextField.secureTextField.placeholder = L10n.labelPassword
        self.passwordTextField.backgroundColor = Asset.backgroundBlueColor.color
        /// repeatPassword  TextField
        self.repeatPasswordTextField.secureTextField.tag = 4
        self.repeatPasswordTextField.inputTextField.textContentType = .password
        self.repeatPasswordTextField.secureTextField.placeholder = L10n.labelRepeatPassword
        self.repeatPasswordTextField.backgroundColor = Asset.backgroundBlueColor.color
    }
    func setupDelegates() {
        emailTextField.inputTextField.delegate = self
        passwordTextField.secureTextField.delegate = self
        userNameTextField.inputTextField.delegate = self
        repeatPasswordTextField.secureTextField.delegate = self
    }
    private func setupButtons() {
        /// setup for login button
        self.registerButton.backgroundColor = Asset.buttonBlueColor.color
        self.registerButton.setTitle(L10n.titleLabelRegister, for: .normal)
        self.registerButton.tintColor = .white
        self.registerButton.layer.cornerRadius = 10
        self.registerButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 || textField.tag == 2 || textField.tag == 3 || textField.tag == 4 {
            if !emailTextField.isError && !passwordTextField.isError &&
                !userNameTextField.isError && !repeatPasswordTextField.isError {
                if passwordTextField.secureTextField.text == repeatPasswordTextField.secureTextField.text {
                    setUpNoMatchingErrorLabel()
                    registerButton.isEnabled = true
                } else {
                    setUpMatchingErrorLabel()
                }
            } else {
                registerButton.isEnabled = false
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 4 {
            setUpNoMatchingErrorLabel()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func setUpMatchingErrorLabel() {
        repeatPasswordTextField.secureTextField.layer.borderWidth = 2
        repeatPasswordTextField.secureTextField.layer.borderColor = UIColor.systemRed.cgColor
        repeatPasswordTextField.errorLabel.isHidden = false
        repeatPasswordTextField.errorLabel.text = L10n.labelErrorMessagePasswordsDontMatch
    }
    
    func setUpNoMatchingErrorLabel() {
        repeatPasswordTextField.errorLabel.isHidden = true
        repeatPasswordTextField.secureTextField.layer.borderWidth = 0
    }
}
