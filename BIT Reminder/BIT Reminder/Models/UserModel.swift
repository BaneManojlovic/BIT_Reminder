//
//  UserModel.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 13.9.23..
//

import Foundation

struct UserModel: Codable {

    var uid: String
    var name: String
    var email: String
    var password: String
    var repeatedPassword: String

    func validateLogin() throws {
        /// validate email textField entry
        if email.isEmpty {
            throw ValidationError.emailEmpty
        } else {
            if !StringHelper.isEmailValid(email) {
                throw ValidationError.emailEmpty
            }
        }
        /// validate password textField entry
        if password.isEmpty {
            throw ValidationError.passwordEmpty
        } else {
            if !StringHelper.isPasswordValid(password) {
                throw ValidationError.passwordInvalid
            }
        }
    }

    func validateRegistration() throws {
        /// validate name textField entry
        if name.isEmpty {
            throw ValidationError.nameEmpty
        } else {
            if !StringHelper.isFullNameValid(name) {
                throw ValidationError.nameInvalid
            }
        }
        /// validate email textField entry
        if email.isEmpty {
            throw ValidationError.emailEmpty
        } else {
            if !StringHelper.isEmailValid(email) {
                throw ValidationError.emailEmpty
            }
        }
        /// validate password textField entry
        if password.isEmpty {
            throw ValidationError.passwordEmpty
        } else {
            if !StringHelper.isPasswordValid(password) {
                throw ValidationError.passwordInvalid
            }
        }
        /// validate repeatedPassword textField entry
        if repeatedPassword.isEmpty {
            throw ValidationError.repeatPasswordEmpty
        } else {
            if !StringHelper.isPasswordValid(repeatedPassword) {
                throw ValidationError.repeatPasswordInvalid
            }
        }
        /// validate does password & repeatedPassword match
        if !password.isEmpty && !repeatedPassword.isEmpty {
            if !StringHelper.repeatPasswordValidation(password, repeatedPassword) {
                throw ValidationError.passwordsDontMatch
            }
        }
    }

    enum ValidationError: Error {
        case nameEmpty
        case nameInvalid
        case emailEmpty
        case emailInvalid
        case passwordEmpty
        case passwordInvalid
        case repeatPasswordEmpty
        case repeatPasswordInvalid
        case passwordsDontMatch
    }
}
