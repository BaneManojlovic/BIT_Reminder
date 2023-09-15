//
//  StringHelper.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 13.9.23..
//

import UIKit

struct StringHelper {
    // check is name valid
    static func isFullNameValid(_ fullName: String) -> Bool {
        let regex = NSPredicate(format: "SELF MATCHES %@", "^([A-Z][a-z]*((\\s)))+[A-Z][a-z]*$")
        return regex.evaluate(with: fullName)
    }
    // check is email valid
    static func isEmailValid(_ email: String) -> Bool {
        let regex = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return regex.evaluate(with: email)
    }
    // check is password valid
    static func isPasswordValid(_ password: String) -> Bool {
        // check if password contains at least one capital letter
        let capitalLetterRegex = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*")
        guard capitalLetterRegex.evaluate(with: password) else { return false }
        // check if password contains at least one number
        let numberRegex = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]{1,}+.*")
        guard numberRegex.evaluate(with: password) else { return false }
        // check if password consists of at least 8 characters
        let lengthRegex = NSPredicate(format: "SELF MATCHES %@",
            "^(?=.*\\d)(?=.*[a-zA-Z]).{8,}$")
        guard lengthRegex.evaluate(with: password) else { return false }

        return true
    }
    // check if password & repeatedPasswords match
    static func repeatPasswordValidation(_ password: String, _ repeatPassword: String) -> Bool {
        if password == repeatPassword {
            return true
        } else {
            return false
        }
    }
}
