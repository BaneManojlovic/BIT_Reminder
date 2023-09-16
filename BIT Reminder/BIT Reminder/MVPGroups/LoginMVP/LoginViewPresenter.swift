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
    func handleValidationError(error: UserModel.ValidationError)
}

class LoginViewPresenter {

    weak var delegate: LoginViewPresenterDelegate?
    var authManager = AuthManager()

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

    func loginWithEmail(user: UserModel) {
        Task {
            do {
                try user.validateLogin()
                try await self.authManager.signInWithEmailAndPassword(email: user.userEmail, password: user.password ?? "") { error, response  in
                    if let error = error {
                        debugPrint(error)
                        self.delegate?.loginActionFailed(error: error.localizedDescription)
                    } else if let session = response {
                        debugPrint("Success")
                        let user = UserModel(profileId: session.user.id.uuidString,
                                             userName: user.userName,
                                             userEmail: session.user.email ?? "")
                        self.userDefaultsHelper.setUser(user: user)
                        self.delegate?.loginActionSuccess()
                    }
                }
            } catch let error as UserModel.ValidationError {
                self.delegate?.handleValidationError(error: error)
            }
        }
    }
}
