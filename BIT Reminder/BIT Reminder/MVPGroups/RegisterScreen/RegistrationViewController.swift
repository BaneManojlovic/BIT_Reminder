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

        if let name = self.registrationView.userNameTextField.text,
           let email = self.registrationView.emailTextField.text,
           let password = self.registrationView.passwordTextField.inputTextField.text,
           let repeatedPassword = self.registrationView.repeatPasswordTextField.inputTextField.text {
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
