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
           let password = self.registrationView.passwordTextField.text,
           let repeatedPassword = self.registrationView.repeatPasswordTextField.text {
            self.presenter.registerNewUserWithEmail(user: UserModel(uid: "",
                                                                    name: name,
                                                                    email: email,
                                                                    password: password,
                                                                    repeatedPassword: repeatedPassword))
        } else {
            self.showOkAlert(message: "Error while Register new user")
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
        debugPrint("Success")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.authFlowController.goToHome()
        }
    }

    func handleValidationError(error: UserModel.ValidationError) {
        switch error {
        case .nameEmpty:
            self.showValidationError(message: "nameEmpty")
        case .nameInvalid:
            self.showValidationError(message: "nameInvalid")
        case .emailEmpty:
            self.showValidationError(message: "emailEmpty")
        case .emailInvalid:
            self.showValidationError(message: "emailInvalid")
        case .passwordEmpty:
            self.showValidationError(message: "passwordEmpty")
        case .passwordInvalid:
            self.showValidationError(message: "passwordInvalid")
        case .repeatPasswordEmpty:
            self.showValidationError(message: "repeatPasswordEmpty")
        case .repeatPasswordInvalid:
            self.showValidationError(message: "repeatPasswordInvalid")
        case .passwordsDontMatch:
            self.showValidationError(message: "passwordsDontMatch")
        }
    }

    func showValidationError(message: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: message)
        }
    }
}
