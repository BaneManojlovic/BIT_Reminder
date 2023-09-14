//
//  SettingsViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 13.9.23..
//

import UIKit

class SettingsViewController: BaseNavigationController {

    var presenter = SettingsViewPresenter()
    lazy private var authFlowController = AuthentificationFlowController(currentViewController: self)

    private var settingsView: SettingsView! {
        loadViewIfNeeded()
        return view as? SettingsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupDelegates()
        self.setupTargets()
    }

    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Settings"
        self.settingsView.setupUI()
    }

    private func setupDelegates() {
        self.presenter.attachView(view: self)
    }

    private func setupTargets() {
        self.settingsView.logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }

    @objc func logout() {
        self.showCancelOrYesAlert(message: "Are you sure you want to logout?",
                                  yesHandler: {
            self.presenter.logoutUser()
        })
    }
}

// MARK: - Conforming to SettingsViewPresenterDelegate

extension SettingsViewController: SettingsViewPresenterDelegate {

    func userLogoutFailure(message: String) {
        self.showOkAlert(message: message)
    }

    func userLogoutSuccess() {
        DispatchQueue.main.async {
            self.authFlowController.goToSplashScreen()
        }
    }
}
