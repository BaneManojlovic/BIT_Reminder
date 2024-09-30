//
//  RegisterViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 8.9.23..
//

import UIKit
import GoTrue

class RegistrationViewController: BaseNavigationController {

    // MARK: - Properties

    var presenter = RegistrationPresenter()

    // MARK: - Private Properties

    lazy private var authFlowController = AuthentificationFlowController(currentViewController: self)
    private var registrationView: RegistrationView! {
        loadViewIfNeeded()
        return view as? RegistrationView
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
        self.navigationController?.isNavigationBarHidden = false
        // set back button
        self.haveBackButton = true
        self.registrationView.setupUI()
    }

    private func setupTargets() {
        self.registrationView.registerButton.addTarget(self, action: #selector(registerButtonAction), for: .touchUpInside)
    }

    private func setupDelegates() {
        self.presenter.attachView(view: self)
    }

    // MARK: - Action Methods

    @objc func registerButtonAction() {

        if let name = self.registrationView.userNameTextField.inputTextField.text,
           let email = self.registrationView.emailTextField.inputTextField.text,
           let password = self.registrationView.passwordTextField.secureTextField.text,
           let repeatedPassword = self.registrationView.repeatPasswordTextField.secureTextField.text {
            self.presenter.registerNewUserWithEmail(user: UserModel(profileId: "",
                                                                    userName: name,
                                                                    userEmail: email,
                                                                    password: password,
                                                                    repeatedPassword: repeatedPassword))
        } else {
            self.showOkAlert(message: L10n.labelMessageErrorWhileRegister)
        }
    }
}

// MARK: - Conforming to RegistrationPresenterDelegate

extension RegistrationViewController: RegistrationPresenterDelegate {

    func registarNewUserActionFailure(error: Error) {
        if let err = error as? GoTrue.GoTrueError {
            switch err {
            case .missingExpClaim:
                break
            case .malformedJWT:
                break
            case .sessionNotFound:
                DispatchQueue.main.async {
                    self.showOkAlert(message: error.localizedDescription)
                }
            case .api(let aPIError):
                DispatchQueue.main.async {
                    self.showOkAlert(message: aPIError.msg ?? "")
                }
            }
        }
    }

    func registarNewUserActionSuccess() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.authFlowController.goToHome()
        }
    }

    func handleValidationError(error: ValidationError) {
        switch error {
        case .nameEmpty:
            registrationView.userNameTextField.errorLabel.text = L10n.labelErrorMessageNameCannotBeEmpty
            registrationView.userNameTextField.setUpErrorView()
        case .nameInvalid:
            registrationView.userNameTextField.errorLabel.text = L10n.labelErrorMessageNameInvalidFormat
            registrationView.userNameTextField.setUpErrorView()
        case .emailEmpty:
            registrationView.emailTextField.errorLabel.text = L10n.labelErrorMessageEmailCannotBeEmpty
            registrationView.emailTextField.setUpErrorView()
        case .emailInvalid:
            registrationView.emailTextField.errorLabel.text = L10n.labelErrorMessageEmailInvalidFormat
            registrationView.emailTextField.setUpErrorView()
        case .passwordEmpty:
            registrationView.passwordTextField.errorLabel.text = L10n.labelErrorMessagePasswCannotBeEmpty
            registrationView.passwordTextField.setUpErrorView()
        case .passwordInvalid:
            registrationView.passwordTextField.errorLabel.text = L10n.labelErrorMessagePasswInvalidFormat
            registrationView.passwordTextField.setUpErrorView()
        case .repeatPasswordEmpty:
            registrationView.repeatPasswordTextField.errorLabel.text = L10n.labelErrorMessageRepeatedPasswCannotBeEmpty
            registrationView.repeatPasswordTextField.setUpErrorView()
        case .repeatPasswordInvalid:
            registrationView.repeatPasswordTextField.errorLabel.text = L10n.labelErrorMessageRepeatedPasswInvalidFormat
            registrationView.repeatPasswordTextField.setUpErrorView()
        case .passwordsDontMatch:
            registrationView.repeatPasswordTextField.errorLabel.text = L10n.labelErrorMessagePasswordsDontMatch
            registrationView.passwordTextField.errorLabel.text = L10n.labelErrorMessagePasswordsDontMatch
            registrationView.passwordTextField.setUpErrorView()
            registrationView.repeatPasswordTextField.setUpErrorView()
        }
    }
}
