//
//  BaseSecureTextFieldView.swift
//  BIT Reminder
//
//  Created by suncica on 16.5.24..
//

import SwiftUI

struct BaseSecureTextFieldView: View {

    var placeholderText: String
    var backgroundColor: Color
    @Binding var text: String

    var body: some View {
        SecureField(placeholderText, text: $text)
            .frame(height: 60)
            .disableAutocorrection(true)
            .submitLabel(.done)
            .textInputAutocapitalization(.never)
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 60))
            .background(backgroundColor)
            .cornerRadius(10)
    }
}
