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
    
    // password errors helper
    
    static func checkBigLetter(text: String) -> Bool {
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format: "SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: text)
        return capitalresult
    }

    static func doStringContainsNumber(text: String) -> Bool {
        
        let numberRegEx  = ".*[0-9]+.*"
        let testCase = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: text)

        return containsNumber
        }

    
    static func validatePassword(text: String) -> (PasswordErrorType, Bool) {
        
        if !text.isEmpty {
            let letter = checkBigLetter(text: text)
            let number = doStringContainsNumber(text: text)
            if text.count < 8 && letter == true && number == true {
                return (PasswordErrorType.noLength, false)
            } else if letter == false && text.count >= 8 && number == true {
                return (PasswordErrorType.noLetter, false)
            } else if number == false && text.count >= 8 && letter == true {
                return (PasswordErrorType.noNumber, false)
            } else if letter == false && number == false && text.count >= 8 {
                return (PasswordErrorType.noNumberandLetter, false)
            } else if letter == false && number == true && text.count < 8 {
                return (PasswordErrorType.noLetterandLength, false)
            } else if number == false && letter == true && text.count < 8 {
                return (PasswordErrorType.noNumberandLength, false)
            } else if number == false && letter == false && text.count < 8 {
                return (PasswordErrorType.noAll, false)
            }
        }
        
        return (PasswordErrorType.noError, true)
    }
}
