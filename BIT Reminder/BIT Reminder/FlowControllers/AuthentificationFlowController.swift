//
//  AuthentificationFlowController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 6.9.23..
//

import UIKit

class AuthentificationFlowController: FlowController {

    func goToSplashScreen() {
        // TODO: - Add here emptying of user defaults
        let splashVC = StoryboardScene.Authentification.splashScreenViewController.instantiate()
        splashVC.presenter = SplashScreenPresenter()
        if let app = UIApplication.shared.delegate as? AppDelegate,
           let window = app.window {
            window.switchRootViewController(splashVC)
        }
    }

    func goToLogin() {
        let loginVC = StoryboardScene.Authentification.loginViewController.instantiate()
        loginVC.presenter = LoginViewPresenter()
        currentViewController.navigationController?.pushViewController(loginVC, animated: true)
    }

    func goToHome() {
        let homeVC = StoryboardScene.Authentification.homeViewController.instantiate()
        homeVC.presenter = HomeViewPresenter()
        currentViewController.navigationController?.pushViewController(homeVC, animated: true)
    }

    func goToRegistration() {
        let regVC = StoryboardScene.Authentification.registrationViewController.instantiate()
        regVC.presenter = RegistrationPresenter()
        currentViewController.navigationController?.pushViewController(regVC, animated: true)
    }

    func goToForgotPassword() { }
}
