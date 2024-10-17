//
//  SecuredEyeButtonView.swift
//  BIT Reminder
//
//  Created by suncica on 16.5.24..
//

import SwiftUI

struct SecuredEyeButtonView: View {

    @Binding var isSecured: Bool

    var body: some View {
        Button(action: {
            isSecured.toggle()
        }, label: {
            Image(systemName: self.isSecured ? "eye.slash" : "eye")
                .accentColor(.gray)
                .offset(x: -20, y: 0)
        })
        .frame(width: 35, height: 55, alignment: .center)
    }
}
