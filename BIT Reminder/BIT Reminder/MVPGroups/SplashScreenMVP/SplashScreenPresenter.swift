//
//  SplashScreenPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 6.9.23..
//

import Foundation

protocol SplashScreenPresenterDelegate: AnyObject {
    func goToLogin()
    func goToHome()
}

class SplashScreenPresenter {

    // MARK: - Properties

    weak var delegate: SplashScreenPresenterDelegate?

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
        // TODO: - Remobe countdown timer this is just for test
        var countdown = 100000
        while countdown > 0 {
            debugPrint("\(countdown)…")
            countdown -= 1
        }
        debugPrint("Open next screen!!!")
        // TODO: - Implement logic for deciding where app flow will go
        // based on user logged in status
        if loggedIn {
            self.delegate?.goToHome()
        } else {
            self.delegate?.goToLogin()
        }
    }
}
