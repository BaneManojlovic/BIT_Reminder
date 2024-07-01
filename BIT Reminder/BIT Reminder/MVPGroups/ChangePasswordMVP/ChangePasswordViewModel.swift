//
//  ChangePasswordViewModel.swift
//  BIT Reminder
//
//  Created by suncica on 20.5.24..
//

import Foundation
import UIKit
import GoTrue
import KRProgressHUD

class ChangePasswordViewModel: ObservableObject {
    
    @Published var password = ""
    @Published var isFormNotValid = true
    @Published var profileValidation: [ValidationError: Bool] = [.passwordInvalid: false]
    var authManager = AuthManager()
    let userDefaults = UserDefaultsHelper()
    
    func updatePassword() {
        KRProgressHUD.show()
        Task {
            do {
                try await authManager.client.auth.update(user: UserAttributes(password: password))
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    KRProgressHUD.dismiss()
                    self.logoutUser()
                }
            } catch {
                KRProgressHUD.dismiss()
                debugPrint("Error reseting password\(error)")
            }
        }
    }
    
    func logoutUser() {
        Task {
            do {
                try await self.authManager.userLogout { error in
                    if let error = error {
                        debugPrint(error)
                    } else {
                        self.userDefaults.removeUser()
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                            self.goToSplashScreen()
                        }
                    }
                }
            }
        }
    }
    func goToSplashScreen() {
        guard let app = UIApplication.shared.delegate as? AppDelegate,
        let window = app.window else { return }

        let splashVC = StoryboardScene.Authentification.splashScreenViewController.instantiate()

        window.switchRootViewController(splashVC)
    }
}
