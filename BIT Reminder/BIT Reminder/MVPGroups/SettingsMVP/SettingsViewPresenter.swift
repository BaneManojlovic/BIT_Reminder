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
}

class SettingsViewPresenter {

    weak var delegate: SettingsViewPresenterDelegate?
    var authManager = AuthManager()
    let userDefaults = UserDefaultsHelper()

    // MARK: - Initialization

    init() { }

    // MARK: - Delegate Methods

    func attachView(view: SettingsViewPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }

    func logoutUser() {
        Task {
            do {
                try await self.authManager.userLogout() { error in
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
}
