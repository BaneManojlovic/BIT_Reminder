//
//  HomeViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 7.9.23..
//

import UIKit

class HomeViewController: BaseViewController {

    // MARK: - Properties

    var presenter = HomeViewPresenter()
    lazy private var authFlowController = AuthentificationFlowController(currentViewController: self)

    // MARK: - Private Properties

    private var homeView: HomeView! {
        loadViewIfNeeded()
        return view as? HomeView
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupDelegates()
        self.setupTargets()
    }

    // MARK: - Private Setup Methods

    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.homeView.setupUI()
    }

    private func setupDelegates() {
        self.presenter.attachView(view: self)
    }

    private func setupTargets() {
        self.homeView.logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }

    @objc func logout() {
        self.presenter.logoutUser()
    }
}

// MARK: - Conforming to HomeViewPresenterDelegate

extension HomeViewController: HomeViewPresenterDelegate {
    func userLogoutSuccess() {
        // TODO: - Create OK Alert pop up for user logout success
        debugPrint("logout success ...")
        DispatchQueue.main.async {
            self.authFlowController.goToSplashScreen()
        }
    }
}
