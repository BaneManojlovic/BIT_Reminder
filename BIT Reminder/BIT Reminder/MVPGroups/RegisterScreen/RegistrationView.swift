//
//  RegisterView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 8.9.23..
//

import UIKit
import IQKeyboardManager

class RegistrationView: IQPreviousNextView {

    // MARK: - Outlets

    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!

    // MARK: - Setup methods

    func setupUI() {
        self.backgroundColor = Asset.backgroundBlueColor.color
        self.setupLabels()
        self.setupTextFields()
        self.setupButtons()
    }

    // MARK: - Private Setup Methods

    private func setupLabels() {
        self.screenTitleLabel.text = "Register"
        self.screenTitleLabel.textColor = .white
        self.screenTitleLabel.textAlignment = .center
        self.screenTitleLabel.font = UIFont.systemFont(ofSize: 48)
    }

    private func setupTextFields() {
        /// userName TextField
        self.userNameTextField.textColor = .white
        self.userNameTextField.font = UIFont.systemFont(ofSize: 20)
        self.userNameTextField.backgroundColor = Asset.textfieldBlueColor.color
        self.userNameTextField.layer.cornerRadius = 10
        self.userNameTextField.attributedPlaceholder = NSAttributedString(
                                                    string: "user name",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        /// email TextField
        self.emailTextField.textColor = .white
        self.emailTextField.font = UIFont.systemFont(ofSize: 20)
        self.emailTextField.backgroundColor = Asset.textfieldBlueColor.color
        self.emailTextField.layer.cornerRadius = 10
        self.emailTextField.attributedPlaceholder = NSAttributedString(
                                                    string: "email",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])

        /// password TextField
        self.passwordTextField.textColor = .white
        self.passwordTextField.font = UIFont.systemFont(ofSize: 20)
        self.passwordTextField.backgroundColor = Asset.textfieldBlueColor.color
        self.passwordTextField.layer.cornerRadius = 10
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.attributedPlaceholder = NSAttributedString(
                                                       string: "password",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])

        /// repeatPassword  TextField
        self.repeatPasswordTextField.textColor = .white
        self.repeatPasswordTextField.font = UIFont.systemFont(ofSize: 20)
        self.repeatPasswordTextField.backgroundColor = Asset.textfieldBlueColor.color
        self.repeatPasswordTextField.layer.cornerRadius = 10
        self.repeatPasswordTextField.isSecureTextEntry = true
        self.repeatPasswordTextField.attributedPlaceholder = NSAttributedString(
                                                       string: "repeat password",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }

    private func setupButtons() {
        /// setup for login button
        self.registerButton.backgroundColor = Asset.buttonBlueColor.color
        self.registerButton.setTitle("Register", for: .normal)
        self.registerButton.tintColor = .white
        self.registerButton.layer.cornerRadius = 10
    }
}
