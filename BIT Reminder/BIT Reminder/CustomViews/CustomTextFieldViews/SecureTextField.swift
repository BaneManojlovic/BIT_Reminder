//
//  SecureTextField.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 16.1.24..
//

import Foundation

class SecureTextField: BaseTextField {

    override func setUpVisibility() {
        isSecureTextEntry = true
    }

}
