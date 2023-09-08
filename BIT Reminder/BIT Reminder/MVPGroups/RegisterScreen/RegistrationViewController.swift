//
//  RegisterViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 8.9.23..
//

import UIKit

class RegistrationViewController: BaseViewController {

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
    }

    // MARK: - Private Setup Methods

    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.registrationView.setupUI()
    }

    private func setupDelegates() {
        self.presenter.attachView(view: self)
    }
}

// MARK: - Conforming to RegistrationPresenterDelegate

extension RegistrationViewController: RegistrationPresenterDelegate { }
