//
//  LoginViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 8.9.23..
//

import UIKit

class LoginViewController: BaseViewController {

    // MARK: - Properties

    var presenter = LoginViewPresenter()

    // MARK: - Private Properties

    lazy private var authFlowController = AuthentificationFlowController(currentViewController: self)
    private var loginView: LoginView! {
        loadViewIfNeeded()
        return view as? LoginView
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupDelegates()
        self.setupTargets()
    }

    // MARK: - Private Setup Methods

    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.loginView.setupUI()
    }

    private func setupDelegates() {
        self.presenter.attachView(view: self)
    }

    private func setupTargets() {
        self.loginView.loginButton.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        self.loginView.registerNewUserButton.addTarget(self, action: #selector(registerUserButtonAction), for: .touchUpInside)
    }

    @objc func loginButtonAction() {
        if let email = self.loginView.emailTextField.text,
           let password = self.loginView.passwordTextField.inputTextField.text {

            self.presenter.loginWithEmail(user: UserModel(profileId: "", // API does not ask for it
                                                          userName: "", // API does not as for it
                                                          userEmail: email,
                                                          password: password,
                                                          repeatedPassword: password))
        } else {
            self.showOkAlert(message: L10n.labelMessageLoginError)
        }
    }

    @objc func registerUserButtonAction() {
        self.authFlowController.goToRegistration()
    }
}

// MARK: - Conforming to LoginViewController

extension LoginViewController: LoginViewPresenterDelegate {

    func loginActionSuccess() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.authFlowController.goToHome()
        }
    }

    func loginActionFailed(error: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: error)
        }
    }

    func handleValidationError(error: UserModel.ValidationError) {
        switch error {
        case .nameEmpty:
            self.showValidationError(message: L10n.labelErrorMessageNameCannotBeEmpty)
        case .nameInvalid:
            self.showValidationError(message: L10n.labelErrorMessageNameInvalidFormat)
        case .emailEmpty:
            self.showValidationError(message: L10n.labelErrorMessageEmailCannotBeEmpty)
        case .emailInvalid:
            self.showValidationError(message: L10n.labelErrorMessageEmailInvalidFormat)
        case .passwordEmpty:
            self.showValidationError(message: L10n.labelErrorMessagePasswCannotBeEmpty)
        case .passwordInvalid:
            self.showPasswordValidationMessage(message: L10n.labelErrorMessagePasswInvalidFormat)
        case .repeatPasswordEmpty:
            self.showValidationError(message: L10n.labelErrorMessageRepeatedPasswCannotBeEmpty)
        case .repeatPasswordInvalid:
            self.showPasswordValidationMessage(message: L10n.labelErrorMessageRepeatedPasswInvalidFormat)
        case .passwordsDontMatch:
            self.showValidationError(message: L10n.labelErrorMessagePasswordsDontMatch)
        }
    }

    func showValidationError(message: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: message)
        }
    }

    func showPasswordValidationMessage(message: String) {
        let passwordInstruction = L10n.labelPasswordExplanation
        DispatchQueue.main.async {
            self.showOkAlert(title: message, message: passwordInstruction)
        }
    }
}
