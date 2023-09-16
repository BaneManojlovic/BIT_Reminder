//
//  RegisterPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 8.9.23..
//

import UIKit
import KRProgressHUD

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
        KRProgressHUD.show()
        Task {
            do {
                try user.validateRegistration()
                try await self.authManager.registerNewUserWithEmailAndPassword(email: user.userEmail, password: user.password ?? "") { error, response  in
                    if let error = error {
                        debugPrint(error.localizedDescription)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                           KRProgressHUD.dismiss()
                        }
                        self.delegate?.registarNewUserActionFailure(error: error)
                    } else if let data = response {
                        let user = UserModel(profileId: data.user.id.uuidString,
                                             userName: user.userName,
                                             userEmail: data.user.email ?? "")
                        self.userDefaults.setUser(user: user)
//                        self.delegate?.registarNewUserActionSuccess()
                        self.saveUserData(user: user)
                    }
                }
            } catch let error as UserModel.ValidationError {
                self.delegate?.handleValidationError(error: error)
            }
        }
    }

    func saveUserData(user: UserModel) {
        Task {
            do {
                try await self.authManager.saveUser(user: user) { error in
                    if let error = error {
                        debugPrint(error.localizedDescription)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                           KRProgressHUD.dismiss()
                        }
                        self.delegate?.registarNewUserActionFailure(error: error)
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                           KRProgressHUD.dismiss()
                        }
                        self.delegate?.registarNewUserActionSuccess()
                    }
                }
            }
        }
    }
}
