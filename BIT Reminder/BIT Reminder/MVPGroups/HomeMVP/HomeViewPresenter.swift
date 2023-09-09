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
}

class HomeViewPresenter {

    weak var delegate: HomeViewPresenterDelegate?
    var authManager = AuthManager()
    let userDefaults = UserDefaults.standard

    // MARK: - Initialization

    init() { }

    // MARK: - Delegate Methods

    func attachView(view: HomeViewPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }

    // TODO: - This method should be implemented on Setting screen.
    // This is here just for test. Will be removed
    func logoutUser() {
        Task {
            do {
                try await self.authManager.userLogout() { error in
                    if let error = error {
                        debugPrint(error)
                    } else {
                        debugPrint("Success")
                        self.userDefaults.removeObject(forKey: "userEmail")
                        self.userDefaults.removeObject(forKey: "userPassword")
                        self.delegate?.userLogoutSuccess()
                    }
                }
            }
        }
    }
}
