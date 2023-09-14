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

        let splashVC = StoryboardScene.Authentification.splashScreenViewController.instantiate()

        window.switchRootViewController(splashVC)
    }

    func goToLogin() {
        guard let app = UIApplication.shared.delegate as? AppDelegate,
        let window = app.window else { return }

        let loginVC = StoryboardScene.Authentification.loginViewController.instantiate()
        loginVC.presenter = LoginViewPresenter()

        // Nest in UINavigationViewContrller because fo goinig in depth for Register new user screen
        window.switchRootViewController(UINavigationController(rootViewController: loginVC))
    }

    func goToHome() {
        guard let app = UIApplication.shared.delegate as? AppDelegate,
        let window = app.window else { return }

        let tabBar = TabBarController()
        window.switchRootViewController(tabBar)
        tabBar.selectedIndex = 0
    }

    func goToRegistration() {
        let regVC = StoryboardScene.Authentification.registrationViewController.instantiate()
        regVC.presenter = RegistrationPresenter()
        currentViewController.navigationController?.pushViewController(regVC, animated: true)
    }

    func goToAddNewReminder() {
        let anrVC = StoryboardScene.Authentification.addNewReminderViewController.instantiate()
        anrVC.presenter = AddNewReminderViewPresenter()
        currentViewController.navigationController?.pushViewController(anrVC, animated: true)
    }

    func goToForgotPassword() { }
}
