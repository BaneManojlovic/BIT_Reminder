//
//  SecureCustomTextFieldView.swift
//  BIT Reminder
//
//  Created by suncica on 16.5.24..
//

import Foundation
import SwiftUI
import Combine

struct SecureCustomTextFieldView: View {

    var text: Binding<String>
    var title: String
    var placeholderText: String
    @Binding var isFormNotValid: Bool
    @Binding var password: String
    @Binding var isInputValid: [ValidationError: Bool]
    @State private var isSecured: Bool = true
    @State private var errorMessage: String = ""
    var fieldContentType: ValidationError
    /// Prefix for UI test identifiers, e.g. "change_password" gives "change_password_input", "_error" and "_toggle".
    var accessibilityIdPrefix: String? = nil

    var body: some View {
        HStack {
            Spacer()
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .foregroundStyle(.white)
                ZStack(alignment: .trailing) {
                    Group {
                        if isSecured {
                            BaseSecureTextFieldView(placeholderText: placeholderText,
                                                    backgroundColor: Color(Asset.textfieldBlueColor.color),
                                                    text: text)
                                .foregroundStyle(.white)
                        } else {
                            BaseTextFieldView(placeholderText: placeholderText,
                                              backgroundColor: Color(Asset.textfieldBlueColor.color),
                                              text: text)
                                .foregroundStyle(.white)
                        }
                    }
                    .accessibilityIdentifier(accessibilityIdPrefix.map { "\($0)_input" } ?? "")
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(
                        isInputValid[fieldContentType] == true || text.wrappedValue.isEmpty ? Color.clear : Color.red, lineWidth: 2))
                    .onChange(of: text.wrappedValue) { newValue in

                        switch fieldContentType {
                        case .passwordInvalid:
                            let result =  StringHelper.validatePassword(text: newValue)
                            if let message = result.0.errorMessages {
                                errorMessage = message
                            }
                            if result.1 == true && !newValue.isEmpty {
                                isInputValid[fieldContentType] = true
                            } else {
                                isInputValid[fieldContentType] = false
                            }

                        default:
                            if newValue.isEmpty {
                                isInputValid[fieldContentType] = false
                            } else {
                                isInputValid[fieldContentType] = true
                            }
                        }
                        isFormNotValid = isInputValid.values.contains(false)
                    }
                    SecuredEyeButtonView(isSecured: $isSecured)
                        .accessibilityIdentifier(accessibilityIdPrefix.map { "\($0)_toggle" } ?? "")
                }
                if isInputValid[fieldContentType] == false && !text.wrappedValue.isEmpty {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .accessibilityIdentifier(accessibilityIdPrefix.map { "\($0)_error" } ?? "")
                }
            }
            Spacer()
                .frame(width: 20)
        }
    }
}
