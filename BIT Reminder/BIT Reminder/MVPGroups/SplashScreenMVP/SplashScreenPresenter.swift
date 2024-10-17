//
//  SplashScreenPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 6.9.23..
//

import Foundation
import GoTrue

protocol SplashScreenPresenterDelegate: AnyObject {
    func goToLogin()
    func goToHome()
    func errorAuthentificationForRetrivedUser(error: Error)
}

class SplashScreenPresenter {

    // MARK: - Properties

    weak var delegate: SplashScreenPresenterDelegate?
    let userDefaults = UserDefaultsHelper()
    var authManager = AuthManager()
    private var loggedIn: Bool = false

    // MARK: - Initialization

    init() { }

    // MARK: - Delegate Methods

    func attachView(view: SplashScreenPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }

    func checkAuthorizationStatus() {
        if self.userDefaults.getUser() != nil {
            self.loggedIn = true
            self.delegate?.goToHome()
        } else {
            self.loggedIn = false
            self.delegate?.goToLogin()
        }
    }

    // This mehod is for checking is user logged in to Supabase
//    func checkForRetrievedUser() {
//        Task {
//            do {
//                try await self.authManager.retrieveUser { error, response in
//                    if let error = error {
//                        self.delegate?.errorAuthentificationForRetrivedUser(error: error)
//                    } else if let responseData = response {
//                        if let userData = responseData as? GoTrue.User {
//                            let user = UserModel(profileId: userData.id.uuidString,
//                                                 userEmail: userData.email ?? "")
//                            self.checkAuthorizationStatus(userData: user)
//                        } else {
//                            debugPrint("error")
//                        }
//                    }
//                }
//            }
//        }
//    }

    func checkAuthorizationStatus(userData: UserModel) {
        if let user = self.userDefaults.getUser() {
            if user.profileId == userData.profileId {
                self.loggedIn = true
                self.delegate?.goToHome()
            }
        } else {
            self.loggedIn = false
            self.delegate?.goToLogin()
        }
    }
}
