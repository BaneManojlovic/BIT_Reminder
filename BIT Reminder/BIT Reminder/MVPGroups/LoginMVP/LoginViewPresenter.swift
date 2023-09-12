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
    func loginActionFailed(error: String)
}

class LoginViewPresenter {

    weak var delegate: LoginViewPresenterDelegate?
    var authManager = AuthManager()
//    let userDefaults = UserDefaults.standard
    private var userDefaultsHelper = UserDefaultsHelper()

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
                try await self.authManager.signInWithEmailAndPassword(email: email, password: password) { error, response  in
                    if let error = error {
                        debugPrint(error)
                        self.delegate?.loginActionFailed(error: error.localizedDescription)
                    } else if let session = response {
                        debugPrint("Success")
                        let user = User(uid: session.user.id.uuidString,
                                        email: session.user.email)
                        self.userDefaultsHelper.setUser(user: user)
                        self.delegate?.loginActionSuccess()
                    }
                }
            }
        }
    }
}
