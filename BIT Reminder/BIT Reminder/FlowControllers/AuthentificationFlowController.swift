//
//  AuthentificationFlowController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 6.9.23..
//

import UIKit

class AuthentificationFlowController: FlowController {

    func goToSplashScreen() {
        guard let app = UIApplication.shared.delegate as? AppDelegate,
        let window = app.window else { return }

        // TODO: - Add here emptying of user defaults
        let splashVC = StoryboardScene.Authentification.splashScreenViewController.instantiate()

        window.switchRootViewController(splashVC)
    }

    func goToLogin() {
        guard let app = UIApplication.shared.delegate as? AppDelegate,
        let window = app.window else { return }

        let loginVC = StoryboardScene.Authentification.loginViewController.instantiate()
        loginVC.presenter = LoginViewPresenter()

        window.switchRootViewController(loginVC)
    }

    func goToHome() {
        guard let app = UIApplication.shared.delegate as? AppDelegate,
        let window = app.window else { return }

        let homeVC = StoryboardScene.Authentification.homeViewController.instantiate()
        homeVC.presenter = HomeViewPresenter()

        window.switchRootViewController(UINavigationController(rootViewController: homeVC))
    }

    func goToRegistration() {
        let regVC = StoryboardScene.Authentification.registrationViewController.instantiate()
        regVC.presenter = RegistrationPresenter()
        currentViewController.navigationController?.pushViewController(regVC, animated: true)
    }

    func goToForgotPassword() { }
}
