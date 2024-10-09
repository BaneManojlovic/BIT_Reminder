//
//  ResetPasswordViewModel.swift
//  BIT Reminder
//
//  Created by suncica on 2.7.24..
//

import Foundation
import UIKit
import KRProgressHUD
import Supabase
import Combine

class ResetPasswordViewModel: ObservableObject {

    @Published var email = ""
    @Published var isFormNotValid = true
    @Published var profileValidation: [ValidationError: Bool] = [.emailInvalid: false]
    @Published var resetSuccess = false
    @Published var errorMessage: String?
    @Published var showingAlert = false

    var isLoading = false
    var authManager = AuthManager()
    var alertManager = AlertManager.shared 
    let userDefaults = UserDefaultsHelper()

    func resetPassword() async {
        DispatchQueue.main.async {
            KRProgressHUD.show()
        }

        Task {
            do {
                guard let url = URL(string: "bitreminder://resetpassword") else {
                    throw URLError(.badURL)
                }
                try await authManager.client.auth.resetPasswordForEmail(email, redirectTo: url)

                DispatchQueue.main.async {
                    KRProgressHUD.dismiss()
                    self.resetSuccess = true
                    self.errorMessage = nil
                    self.showingAlert = true
                }
            } catch {
                DispatchQueue.main.async {
                    KRProgressHUD.dismiss()
                    self.resetSuccess = false
                    self.errorMessage = "Error resetting password: \(error.localizedDescription)"
                    self.showingAlert = false
                    self.alertManager.triggerAlert(for: error)
                }
            }
        }
    }

}
