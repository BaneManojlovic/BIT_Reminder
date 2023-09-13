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
        // TODO: - First here make data validation check
        self.presenter.registerNewUserWithEmail(email: "bobbobovic@gmail.com",
                                                password: "MarkoMarkovic123")
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
            self.authFlowController.goToMainScreen()
        }
    }
}
