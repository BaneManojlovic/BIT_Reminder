//
//  BaseTextFieldView.swift
//  BIT Reminder
//
//  Created by suncica on 16.5.24..
//

import Foundation
import SwiftUI

struct BaseTextFieldView: View {

    var placeholderText: String
    var backgroundColor: Color
    @Binding var text: String

    var body: some View {
        TextField(placeholderText, text: $text)
            .frame(height: 60)
            .disableAutocorrection(true)
            .submitLabel(.done)
            .textInputAutocapitalization(.never)
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 40))
            .background(backgroundColor)
            .cornerRadius(10)
    }
}
