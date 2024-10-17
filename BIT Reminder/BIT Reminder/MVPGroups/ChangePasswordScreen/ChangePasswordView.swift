//
//  ChangePasswordView.swift
//  BIT Reminder
//
//  Created by suncica on 20.5.24..
//

import SwiftUI

struct ChangePasswordView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.dismiss) var dismiss
    @StateObject private var changePasswordViewModel = ChangePasswordViewModel()
    @StateObject private var alertManager = AlertManager.shared

    var accessToken: String?
    var refreshToken: String?

    var body: some View {
        VStack(spacing: 20) {

            Spacer()
                .frame(height: 20)
            SecureCustomTextFieldView(text: $changePasswordViewModel.password,
                                      title: L10n.titleLabelEnterNewPassword + ":",
                                      placeholderText: L10n.labelPassword,
                                      isFormNotValid: $changePasswordViewModel.isFormNotValid,
                                      password: $changePasswordViewModel.password,
                                      isInputValid: $changePasswordViewModel.profileValidation,
                                      fieldContentType: .passwordInvalid)
            Spacer()
                .frame(height: 10)

            Button(L10n.titleLabelChangePassword) {
                self.changePasswordViewModel.updatePassword()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .disabled(changePasswordViewModel.password.isEmpty || changePasswordViewModel.isFormNotValid)
            .disabled($changePasswordViewModel.isFormNotValid.wrappedValue)
            .background(Color(Asset.darkOrange.color))
            .foregroundColor((changePasswordViewModel.password.isEmpty || changePasswordViewModel.isFormNotValid) ? Color(Asset.disabledDarkGrayColor.color) : .white)
            .clipShape(Capsule())
            .padding(.horizontal, 20)

            Spacer()
        }

        .onAppear {
            changePasswordViewModel.accessToken = accessToken
            changePasswordViewModel.refreshToken = refreshToken
            changePasswordViewModel.isFormNotValid = true
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color(Asset.backgroundBlueColor.color))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)

        .alert(isPresented: Binding<Bool>(
            get: {
                changePasswordViewModel.showingAlert || alertManager.showAlert
            },
            set: { newValue in
                if changePasswordViewModel.showingAlert {
                    changePasswordViewModel.showingAlert = newValue
                }
                if alertManager.showAlert {
                    alertManager.showAlert = newValue
                }
            }
        )) {
            if changePasswordViewModel.showingAlert {
                if changePasswordViewModel.passwordChangeSuccess {
                    return Alert(
                        title: Text(""),
                        message: Text("Password updated successfully!"),
                        dismissButton: .default(Text("OK"), action: {
                            changePasswordViewModel.logoutUser()
                        })
                    )
                } else {
                    return Alert(
                        title: Text("Error"),
                        message: Text(changePasswordViewModel.errorMessage ?? ""),
                        dismissButton: .default(Text("OK"))
                    )
                }
            } else if alertManager.showAlert {
                return Alert(
                    title: Text(alertManager.alertMessage),
                    message: Text(""),
                    dismissButton: .default(Text("OK"))
                )
            } else {
                return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("OK")))
            }
        }

        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(L10n.titleLabelChangePassword)
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .toolbar {
            if refreshToken == nil {
                 ToolbarItem(placement: .topBarLeading) {
                     Button {
                         self.presentationMode.wrappedValue.dismiss()
                     } label: {
                         Image(systemName: "arrow.left")
                             .foregroundStyle(.white)
                     }
                 }
             }
         }
     }
 }
