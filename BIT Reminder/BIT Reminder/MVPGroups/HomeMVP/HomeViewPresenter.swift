//
//  HomeViewPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 7.9.23..
//

import Foundation
import Supabase

protocol HomeViewPresenterDelegate: AnyObject {
    func userLogoutSuccess()
    func userLogoutFailure(message: String)
}

class HomeViewPresenter {

    weak var delegate: HomeViewPresenterDelegate?
    var authManager = AuthManager()
    let userDefaults = UserDefaultsHelper()
    var userEmail: String?
    var screenName: String?

    // MARK: - Initialization

    init() { }

    // MARK: - Delegate Methods

    func attachView(view: HomeViewPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }

    // TODO: - This method should be implemented on Settings screen.
    // This is here just for test. Will be removed
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
