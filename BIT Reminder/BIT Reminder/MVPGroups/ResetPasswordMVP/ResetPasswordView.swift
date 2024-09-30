//
//  ResetPasswordView.swift
//  BIT Reminder
//
//  Created by suncica on 2.7.24..
//

import SwiftUI
import Supabase

struct ResetPasswordView: View {
    
    weak var navigationController: UINavigationController?
    @Environment(\.dismiss) var dismiss
    @StateObject private var resetPasswordViewModel = ResetPasswordViewModel()
    @State var disableTextField = false
    
    var body: some View {
        
        VStack {
            VStack {
                Spacer()
                    .frame(height: 20)
                // Email Field
                BaseCustomTextFieldView(
                    text: $resetPasswordViewModel.email,
                    title: L10n.titlePlaceholderEnterYourEmail + ":",
                    placeholderText: L10n.labelEmail,
                    isFormNotValid: $resetPasswordViewModel.isFormNotValid,
                    fieldContentType: .emailInvalid,
                    isInputValid: $resetPasswordViewModel.profileValidation,
                    isEditMode: false
                )
                .foregroundStyle(.white)
                .disabled(disableTextField)

                VStack(alignment: .center, spacing: 20) {
                    Button(L10n.titleLableResetPassword) {
                        Task {
                            do {
                                await resetPasswordViewModel.resetPassword()
                            } catch {
                                debugPrint("Error initializing user or resetting password: \(error)")
                            }
                        }
                    }
                    .disabled(resetPasswordViewModel.email.isEmpty || resetPasswordViewModel.isFormNotValid)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color("darkOrange"))
                    .foregroundColor((resetPasswordViewModel.email.isEmpty || resetPasswordViewModel.isFormNotValid) ? Color("orange_disabled_color") : .white)
                    .clipShape(Capsule())
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            Spacer()
        }
        .alert(L10n.titleAlertResetLinkSent, isPresented: $resetPasswordViewModel.showingAlert) {
            Button(L10n.alertButtonTitleOk) {
                dismiss()
            }
        } message: {
            Text(resetPasswordViewModel.resetSuccess ? "Reset password link sent successfully." : (resetPasswordViewModel.errorMessage ?? "An unknown error occurred"))
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("background_blue_color"))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    self.navigationController?.popViewController(animated: true)
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(.white)
                }
            }
        }
    }
}
