//
//  SettingsViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 13.9.23..
//

import UIKit
import SwiftUI

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
        self.presenter.setupSettingsList()
    }

    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = L10n.titleLabelSettings
        self.settingsView.setupUI()
    }

    private func setupDelegates() {
        self.presenter.attachView(view: self)
        self.settingsView.tableView.delegate = self
        self.settingsView.tableView.dataSource = self
    }

    private func setupTargets() { }

    @objc func logout() {
        self.showCancelOrYesAlert(message: L10n.labelMessageSureWantLogout,
                                  yesHandler: {
            self.presenter.logoutUser()
        })
    }

    @objc func deleteUserAccount() {
        self.showCancelOrYesAlert(message: L10n.labelMessageSureWantDeleteAccount,
                                  yesHandler: {
            self.presenter.deleteUser()
        })
    }
}

// MARK: - Conforming to SettingsViewPresenterDelegate

extension SettingsViewController: SettingsViewPresenterDelegate {

    func getUserDataSuccess(user: [UserModel]) {
        DispatchQueue.main.async {
            if let userData = user.first {
                self.presenter.userDefaults.setUser(user: userData)
            }
        }
    }

    func getUserDataFailure(message: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: message)
        }
    }

    func userLogoutFailure(message: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: message)
        }
    }

    func userLogoutSuccess() {
        DispatchQueue.main.async {
            self.authFlowController.goToSplashScreen()
        }
    }
}

// MARK: - Conforming to UITableViewDelegate, UITableViewDataSource

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.settingsModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseIdentifier,
        for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        /// create model to fill in data for cell
        let model = self.presenter.settingsModel[indexPath.row]
        /// fill cell with model data
        cell.fillCellData(text: model.title)
        /// return cell
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(UIHostingController(rootView: ProfileView(navigationController: self.navigationController)), animated: true)
            self.tabBarController?.tabBar.isHidden = true
        case 1:
            self.authFlowController.goToPrivacyPolicy()
        case 2:
            self.logout()
        case 3:
            self.deleteUserAccount()
        default:
            break
        }
    }
}
