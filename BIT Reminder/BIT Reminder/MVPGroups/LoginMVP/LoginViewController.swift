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
        debugPrint("Login tapped ...")
        self.presenter.loginWithEmail(email: "branislav.manojlovic@vegait.rs", password: "BakiMaki106")
    }
    
    @objc func registerUserButtonAction() {
        debugPrint("Register tapped ...")
        self.authFlowController.goToRegistration()
    }
}

// MARK: - Conforming to LoginViewController

extension LoginViewController: LoginViewPresenterDelegate {

    func loginActionSuccess() {
        debugPrint("Login ... SUCCESS ...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.authFlowController.goToHome()
        }
    }

    func loginActionFailed() {
        debugPrint("Login ... Failed")
    }
}
