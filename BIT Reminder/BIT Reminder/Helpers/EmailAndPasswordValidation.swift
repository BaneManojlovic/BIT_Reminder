//
//  EmailAndPasswordValidation.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 29.1.24..
//

import UIKit

class EmailAndPasswordValidation {

    // check is name valid
    static func isFullNameValid(textField: UITextField) -> Bool {
        let regex = NSPredicate(format: "SELF MATCHES %@", "^([A-Z][a-z]*((\\s)))+[A-Z][a-z]*$")
        return regex.evaluate(with: textField.text)
    }
    static func isValidEmail(textField: UITextField) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if let email = textField.text {
            return emailPred.evaluate(with: email)
        }
        return false
    }
    static func isPasswordValid(textField: UITextField) -> Bool {

        // check if password contains at least one capital letter
        let capitalLetterRegex = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*")
        guard capitalLetterRegex.evaluate(with: textField.text) else { return false }
        // check if password contains at least one number
        let numberRegex = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]{1,}+.*")
        guard numberRegex.evaluate(with: textField.text) else { return false }
        // check if password consists of at least 8 characters
        let lengthRegex = NSPredicate(format: "SELF MATCHES %@",
            "^(?=.*\\d)(?=.*[a-zA-Z]).{8,}$")
        guard lengthRegex.evaluate(with: textField.text) else { return false }

        return true
    }

    // check if password & repeatedPasswords match
    static func repeatPasswordValidation(password: UITextField, repeatPassword: UITextField) -> Bool {
        if password.text == repeatPassword.text {
            return true
        } else {
            return false
        }
    }
}
