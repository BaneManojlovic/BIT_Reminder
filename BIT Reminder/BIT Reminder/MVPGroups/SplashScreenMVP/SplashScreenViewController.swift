//
//  SplashScreenViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 6.9.23..
//

import UIKit
import GoTrue

class SplashScreenViewController: BaseViewController {

    // MARK: - Properties

    var presenter = SplashScreenPresenter()

    lazy private var authFlowController = AuthentificationFlowController(currentViewController: self)

    // MARK: - Private Properties

    private var splashScreenView: SplashScreenView! {
        loadViewIfNeeded()
        return view as? SplashScreenView
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupDelegates()
//        self.presenter.checkForRetrievedUser()
        self.presenter.checkAuthorizationStatus()
    }

    // MARK: - Private Setup Methods

    private func setupUI() {
        self.splashScreenView.setupUI()
    }

    private func setupDelegates() {
        self.presenter.attachView(view: self)
    }
}

// MARK: - Conforming to SplashScreenPresenterDelegate

extension SplashScreenViewController: SplashScreenPresenterDelegate {

    func errorAuthentificationForRetrivedUser(error: Error) {
        if let err = error as? GoTrue.GoTrueError {
            switch err {
            case .missingExpClaim:
                break
            case .malformedJWT:
                break
            case .sessionNotFound:
                self.goToLogin()
            case .api(let aPIError):
                break
            }
        } else {
            DispatchQueue.main.async {
                self.showOkAlert(message: error.localizedDescription, completion: {
                    self.goToLogin()
                })
            }
        }
    }

    func goToLogin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.authFlowController.goToLogin()
        }
    }

    func goToHome() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.authFlowController.goToHome()
        }
    }
}
