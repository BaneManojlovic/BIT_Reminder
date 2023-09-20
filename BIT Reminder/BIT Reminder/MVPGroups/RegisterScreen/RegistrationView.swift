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
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var repeatPasswordTextField: PasswordTextField!
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
        self.userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.userNameTextField.layer.masksToBounds = true
        self.userNameTextField.layer.cornerRadius = 10
        self.userNameTextField.attributedPlaceholder = NSAttributedString(
                                                    string: "user name",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        /// email TextField
        self.emailTextField.textColor = .white
        self.emailTextField.font = UIFont.systemFont(ofSize: 20)
        self.emailTextField.backgroundColor = Asset.textfieldBlueColor.color
        self.emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.emailTextField.layer.masksToBounds = true
        self.emailTextField.layer.cornerRadius = 10
        self.emailTextField.attributedPlaceholder = NSAttributedString(
                                                    string: "email",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])

        /// password TextField
        self.passwordTextField.inputTextField.textContentType = .newPassword
        self.passwordTextField.inputTextField.attributedPlaceholder = NSAttributedString(
                                                       string: "password",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])

        /// repeatPassword  TextField
        self.repeatPasswordTextField.inputTextField.textContentType = .password
        self.repeatPasswordTextField.inputTextField.attributedPlaceholder = NSAttributedString(
                                                       string: "repeat password",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }

    private func setupButtons() {
        /// setup for login button
        self.registerButton.backgroundColor = Asset.buttonBlueColor.color
        self.registerButton.setTitle("Register", for: .normal)
        self.registerButton.tintColor = .white
        self.registerButton.layer.cornerRadius = 10
    }
}
