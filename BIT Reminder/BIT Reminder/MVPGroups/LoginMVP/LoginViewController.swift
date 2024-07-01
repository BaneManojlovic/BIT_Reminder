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
        if let email = self.loginView.emailTextField.inputTextField.text,
           let password = self.loginView.passwordTextField.secureTextField.text {

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

    func handleValidationError(error: ValidationError) {
        switch error {
        case .emailEmpty:
            loginView.emailTextField.errorLabel.text = L10n.labelErrorMessageEmailCannotBeEmpty
            loginView.emailTextField.setUpErrorView()
        case .emailInvalid:
            loginView.emailTextField.errorLabel.text = L10n.labelErrorMessageEmailInvalidFormat
            loginView.emailTextField.setUpErrorView()
        case .passwordEmpty:
            loginView.passwordTextField.errorLabel.text = L10n.labelErrorMessagePasswCannotBeEmpty
            loginView.passwordTextField.setUpErrorView()
        case .passwordInvalid:
            loginView.passwordTextField.errorLabel.text = L10n.labelErrorMessagePasswInvalidFormat
            loginView.passwordTextField.setUpErrorView()
        default:
            debugPrint("No matching cases")
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
