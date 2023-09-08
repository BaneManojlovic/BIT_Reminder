//
//  SplashScreenViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 6.9.23..
//

import UIKit

class SplashScreenViewController: BaseViewController {

    // MARK: - Properties

    var presenter = SplashScreenPresenter()

    lazy private var authFlowController = AuthentificationFlowController(currentViewController: self)
//    lazy private var homeFlowController = HomeFlowController(currentViewController: self)

    // MARK: - Private Properties

    private var splashScreenView: SplashScreenView! {
        loadViewIfNeeded()
        return view as? SplashScreenView
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupDelegates()
        self.presenter.checkAuthorizationStatus()
    }

    // MARK: - Private Setup Methods

    private func setupUI() {
        self.splashScreenView.setupUI()
    }

    private func setupDelegates() {
        self.presenter.attachView(view: self)
    }
}

// MARK: - Conforming to SplashScreenPresenterDelegate

extension SplashScreenViewController: SplashScreenPresenterDelegate {

    func goToLogin() {
        self.authFlowController.goToLogin()
    }

    func goToHome() {
        self.authFlowController.goToHome()
    }
}
