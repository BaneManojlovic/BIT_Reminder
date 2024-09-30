//
//  BaseCustomTextFieldView.swift
//  BIT Reminder
//
//  Created by suncica on 16.5.24..
//

import Foundation

import SwiftUI

struct BaseCustomTextFieldView: View {

    var text: Binding<String>
    var placeholderText: String
    @Binding var isFormNotValid: Bool
    var fieldContentType: ValidationError
    @State private var errorMessage = ""
    @Binding var isInputValid: [ValidationError: Bool]
    var isEditMode: Bool
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 10) {
                Text(placeholderText)
                BaseTextFieldView(placeholderText: placeholderText, backgroundColor: (isEditMode == false ? Color("tableview_cell_blue_color") : Color ("textfield_blue_color")), text: text)
                    .keyboardType(.default)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(isInputValid[fieldContentType] == true || text.wrappedValue.isEmpty ? Color.clear : Color.red, lineWidth: 2))
                    .onChange(of: text.wrappedValue) { newValue in

                        switch fieldContentType {
                        case .emailInvalid:
                            if StringHelper.isEmailValid(newValue) {

                                isInputValid[fieldContentType] = true
                            } else {
                                $errorMessage.wrappedValue = L10n.labelErrorMessageEmailInvalidFormat
                                isInputValid[fieldContentType] = false
                            }
                        case .nameInvalid:
                            if StringHelper.isFullNameValid(newValue) {
                                $errorMessage.wrappedValue = L10n.labelErrorMessageNameInvalidFormat
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

                if isInputValid[fieldContentType] == false && !text.wrappedValue.isEmpty {
                    Text($errorMessage.wrappedValue)
                        .font(.footnote)
                }
            }
            Spacer()
                .frame(width: 20)
        }
        .background(Color.clear)
    }
}
