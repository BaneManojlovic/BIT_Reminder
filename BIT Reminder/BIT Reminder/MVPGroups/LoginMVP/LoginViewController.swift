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

    private var loginView: LoginView! {
        loadViewIfNeeded()
        return view as? LoginView
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupDelegates()
    }

    // MARK: - Private Setup Methods

    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.loginView.setupUI()
    }

    private func setupDelegates() {
        self.presenter.attachView(view: self)
    }

}

// MARK: - Conforming to LoginViewController

extension LoginViewController: LoginViewPresenterDelegate { }
