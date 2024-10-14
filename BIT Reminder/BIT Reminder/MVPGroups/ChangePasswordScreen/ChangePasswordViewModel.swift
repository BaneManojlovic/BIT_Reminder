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
    @Published var showingAlert = false
    @Published var errorMessage: String?
    @Published var passwordChangeSuccess = false

    var authManager = AuthManager()
    var alertManager = AlertManager.shared 
    let userDefaults = UserDefaultsHelper()
    var accessToken: String?
    var refreshToken: String?

    func updatePassword() {
        guard let accessToken = userDefaults.getAccessToken(), !accessToken.isEmpty else {
            KRProgressHUD.showError(withMessage: L10n.alertMessageSessionNotFound)
                   return
              }
        KRProgressHUD.show()

        Task {
            do {

                debugPrint("Access Token: \(accessToken), Refresh Token: \(String(describing: refreshToken))")
                // Update the Supabase session with the access and refresh token (only needed if reset password is trigered)
                if refreshToken != nil {
                    try await authManager.client.auth.setSession(accessToken: accessToken, refreshToken: refreshToken ?? "")
                }

                debugPrint("Attempting to update password to: \(password)")

                try await authManager.client.auth.update(user: UserAttributes(password: password, emailChangeToken: accessToken))
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    KRProgressHUD.dismiss()
                    self.passwordChangeSuccess = true
                    self.showingAlert = true
                }
            } catch {
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    debugPrint("Error changing password: \(error)")
                    KRProgressHUD.dismiss()
                    self.showingAlert = true
                    self.passwordChangeSuccess = false
                    self.errorMessage = "Error changing password: \(error.localizedDescription)"
                    self.alertManager.triggerAlert(for: error)
                }


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
