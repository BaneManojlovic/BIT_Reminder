//
//  SettingsViewPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 13.9.23..
//

import Foundation

protocol SettingsViewPresenterDelegate: AnyObject {
    func userLogoutFailure(message: String)
    func userLogoutSuccess()
    func getUserDataSuccess(user: [UserModel])
    func getUserDataFailure(message: String)
}

class SettingsViewPresenter {

    weak var delegate: SettingsViewPresenterDelegate?
    var authManager = AuthManager()
    let userDefaults = UserDefaultsHelper()
    var settingsModel: [SettingsModel] = []

    // MARK: - Initialization

    init() { }

    // MARK: - Delegate Methods

    func attachView(view: SettingsViewPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }

    func setupSettingsList() {
        self.settingsModel = []
        self.settingsModel.append(SettingsModel(title: "Profile"))
        self.settingsModel.append(SettingsModel(title: "Tutorial"))
        self.settingsModel.append(SettingsModel(title: "Terms & Conditions"))
        self.settingsModel.append(SettingsModel(title: "Logout"))
        self.getUserData()
    }

    func logoutUser() {
        Task {
            do {
                try await self.authManager.userLogout { error in
                    if let error = error {
                        self.delegate?.userLogoutFailure(message: error.localizedDescription)
                    } else {
                        self.userDefaults.removeUser()
                        self.delegate?.userLogoutSuccess()
                    }
                }
            }
        }
    }

    func getUserData() {
        Task {
            do {
                try await self.authManager.getUserData { error, response in
                    if let error = error {
                        debugPrint(error)
                        self.delegate?.getUserDataFailure(message: error.localizedDescription)
                    } else {
                        if let resp = response {
                            debugPrint(response)
                            self.delegate?.getUserDataSuccess(user: resp)
                        }
                    }
                }
            }
        }
    }
}
