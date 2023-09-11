//
//  RegisterViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 8.9.23..
//

import UIKit

class RegistrationViewController: BaseNavigationController {

    // MARK: - Properties

    var presenter = RegistrationPresenter()

    // MARK: - Private Properties

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
        debugPrint("Register tapped ...")
    }
}

// MARK: - Conforming to RegistrationPresenterDelegate

extension RegistrationViewController: RegistrationPresenterDelegate { }
