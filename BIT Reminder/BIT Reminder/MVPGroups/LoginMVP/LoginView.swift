//
//  LoginView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 8.9.23..
//

import UIKit
import IQKeyboardManager

class LoginView: IQPreviousNextView {

    // MARK: - Outlets

    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
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
        self.screenTitleLabel.text = "Login"
        self.screenTitleLabel.textColor = .white
        self.screenTitleLabel.textAlignment = .center
        self.screenTitleLabel.font = UIFont.systemFont(ofSize: 48)
    }

    private func setupTextFields() {
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
        self.passwordTextField.attributedPlaceholder = NSAttributedString(
                                                       string: "password",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }

    private func setupButtons() {
        /// setup for register new user button
        self.registerNewUserButton.backgroundColor = .clear
        self.registerNewUserButton.setTitle("Register new user", for: .normal)
        self.registerNewUserButton.contentHorizontalAlignment = .center
        self.registerNewUserButton.tintColor = .white
        /// setup for login button
        self.loginButton.backgroundColor = Asset.buttonBlueColor.color
        self.loginButton.setTitle("Login", for: .normal)
        self.loginButton.tintColor = .white
        self.loginButton.layer.cornerRadius = 10
    }
}
