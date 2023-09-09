//
//  LoginPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 8.9.23..
//

import UIKit
import Supabase

protocol LoginViewPresenterDelegate: AnyObject {
    func loginActionSuccess()
    func loginActionFailed()
}

class LoginViewPresenter {

    weak var delegate: LoginViewPresenterDelegate?
    var authManager = AuthManager()
    let userDefaults = UserDefaults.standard

    // MARK: - Initialization

    init() { }

    // MARK: - Delegate Methods

    func attachView(view: LoginViewPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }

    func loginWithEmail(email: String, password: String) {
        Task {
            do {
                try await self.authManager.signInWithEmailAndPassword(email: email, password: password) { error in
                    if let error = error {
                        debugPrint(error)
                    } else {
                        debugPrint("Success")
                        DispatchQueue.main.async {
                            self.userDefaults.set(email, forKey: "userEmail")
                            self.userDefaults.set(password, forKey: "userPassword")
                        }
                        self.delegate?.loginActionSuccess()
                    }
                }
            }
        }
    }
}
