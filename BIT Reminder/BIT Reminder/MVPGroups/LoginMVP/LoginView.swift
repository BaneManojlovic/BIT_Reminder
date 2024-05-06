//
//  LoginView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 8.9.23..
//

import UIKit
import IQKeyboardManager

class LoginView: IQPreviousNextView, UITextFieldDelegate {

    // MARK: - Outlets

    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: EmailInputTextFieldView!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var registerNewUserButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    // MARK: - Setup Methods

    func setupUI() {
        self.backgroundColor = Asset.backgroundBlueColor.color
        self.setupLabels()
        self.setupTextFields()
        self.setupButtons()
    }

    // MARK: - Private Setup Methods

    private func setupLabels() {
        self.screenTitleLabel.text = L10n.titleLabelLogin
        self.screenTitleLabel.textColor = .white
        self.screenTitleLabel.textAlignment = .center
        self.screenTitleLabel.font = UIFont.systemFont(ofSize: 48)
    }

    private func setupTextFields() {
        emailTextField.inputTextField.tag = 1
        passwordTextField.secureTextField.tag = 2
        emailTextField.inputTextField.delegate = self
        passwordTextField.secureTextField.delegate = self
        self.emailTextField.inputTextField.placeholder = L10n.labelEmail
        self.passwordTextField.secureTextField.placeholder = L10n.labelPassword
    }

    private func setupButtons() {
        /// setup for register new user button
        self.registerNewUserButton.backgroundColor = .clear
        self.registerNewUserButton.setTitle(L10n.labelMessageRegisterNewUser, for: .normal)
        self.registerNewUserButton.contentHorizontalAlignment = .center
        self.registerNewUserButton.tintColor = .white
        /// setup for login button
        self.loginButton.backgroundColor = Asset.buttonBlueColor.color
        self.loginButton.setTitle(L10n.titleLabelLogin, for: .normal)
        self.loginButton.tintColor = .white
        self.loginButton.layer.cornerRadius = 10
        self.loginButton.isEnabled = false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 || textField.tag == 2 {
            if !emailTextField.isError && !passwordTextField.isError {
                loginButton.isEnabled = true
            } else {
                loginButton.isEnabled = false
            }
        }
    }

}
