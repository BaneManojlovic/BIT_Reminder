//
//  HomeViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 7.9.23..
//

import UIKit

class HomeViewController: BaseViewController {

    // MARK: - Properties

    var presenter = HomeViewPresenter()
    lazy private var authFlowController = AuthentificationFlowController(currentViewController: self)

    // MARK: - Private Properties

    private var homeView: HomeView! {
        loadViewIfNeeded()
        return view as? HomeView
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
        self.homeView.setupUI()
    }

    private func setupDelegates() {
        self.presenter.attachView(view: self)
    }

    private func setupTargets() {
        self.homeView.logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }

    @objc func logout() {
        self.showCancelOrYesAlert(message: "Are you sure you want to logout?",
                                  yesHandler: {
            self.presenter.logoutUser()
        })
    }
}

// MARK: - Conforming to HomeViewPresenterDelegate

extension HomeViewController: HomeViewPresenterDelegate {

    func userLogoutFailure(message: String) {
        self.showOkAlert(message: message)
    }

    func userLogoutSuccess() {
        DispatchQueue.main.async {
            self.authFlowController.goToSplashScreen()
        }
    }
}
