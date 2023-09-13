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
        self.presenter.loginWithEmail(email: "branislav.manojlovic@vegait.rs", password: "MarkoMarkovic123")
    }

    @objc func registerUserButtonAction() {
        self.authFlowController.goToRegistration()
    }
}

// MARK: - Conforming to LoginViewController

extension LoginViewController: LoginViewPresenterDelegate {

    func loginActionSuccess() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.authFlowController.goToMainScreen()
        }
    }

    func loginActionFailed(error: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: error)
        }
    }
}
