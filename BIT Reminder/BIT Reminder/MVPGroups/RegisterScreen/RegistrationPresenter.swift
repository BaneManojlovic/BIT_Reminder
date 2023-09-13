//
//  RegisterPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 8.9.23..
//

import UIKit

protocol RegistrationPresenterDelegate: AnyObject {
    func registarNewUserActionSuccess()
    func registarNewUserActionFailure(error: Error)
    func handleValidationError(error: UserModel.ValidationError)
}

class RegistrationPresenter {

    weak var delegate: RegistrationPresenterDelegate?
    var authManager = AuthManager()
    let userDefaults = UserDefaultsHelper()

    // MARK: - Initialization

    init() { }

    // MARK: - Delegate Methods

    func attachView(view: RegistrationPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }

    func registerNewUserWithEmail(user: UserModel) {
        Task {
            do {
                try user.validateRegistration()
                try await self.authManager.registerNewUserWithEmailAndPassword(email: user.email, password: user.password) { error, response  in
                    if let error = error {
                        debugPrint(error.localizedDescription)
                        self.delegate?.registarNewUserActionFailure(error: error)
                    } else if let data = response {
                        let user = User(uid: data.user.id.uuidString,
                                        email: data.user.email)
                        self.userDefaults.setUser(user: user)
                        self.delegate?.registarNewUserActionSuccess()
                    }
                }
            } catch let error as UserModel.ValidationError {
                self.delegate?.handleValidationError(error: error)
            }
        }
    }
}
