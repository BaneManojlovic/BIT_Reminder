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
        self.presenter.setupSettingsList()
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
        self.settingsView.tableView.delegate = self
        self.settingsView.tableView.dataSource = self
    }

    private func setupTargets() { }

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
            debugPrint("0")
            self.showOkAlert(message: "Not yet implemented!")
        case 1:
            debugPrint("1")
            self.showOkAlert(message: "Not yet implemented!")
        case 2:
            debugPrint("2")
            self.showOkAlert(message: "Not yet implemented!")
        case 3:
            debugPrint("3")
            self.logout()
        default:
            break
        }
    }
}
