//
//  ChangePasswordView.swift
//  BIT Reminder
//
//  Created by suncica on 20.5.24..
//

import SwiftUI

struct ChangePasswordView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var changePasswordVC = ChangePasswordViewModel()
    var accessToken: String?
    var refreshToken: String?

    var body: some View {
        VStack(spacing: 20) {

            Spacer()
                .frame(height: 20)
            SecureCustomTextFieldView(text: $changePasswordVC.password,
                                      placeholderText: L10n.titleLabelEnterNewPassword,
                                      isFormNotValid: $changePasswordVC.isFormNotValid,
                                      password: $changePasswordVC.password,
                                      isInputValid: $changePasswordVC.profileValidation,
                                      fieldContentType: .passwordInvalid)
            Spacer()
                .frame(height: 10)

            Button(L10n.titleLabelChangePassword) {
                self.changePasswordVC.updatePassword()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .disabled(changePasswordVC.password.isEmpty || changePasswordVC.isFormNotValid)
            .disabled($changePasswordVC.isFormNotValid.wrappedValue)
            .background(.orange)
            .clipShape(Capsule())
            .padding(.horizontal, 20)

            Spacer()
        }

        .onAppear {
            changePasswordVC.accessToken = accessToken
            changePasswordVC.refreshToken = refreshToken
            changePasswordVC.isFormNotValid = true
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("background_blue_color"))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)

        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(L10n.titleLabelChangePassword)
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .toolbar {
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
