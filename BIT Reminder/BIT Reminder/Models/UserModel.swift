//
//  UserModel.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 13.9.23..
//

import Foundation

struct UserModel: Codable {

    var profileId: String // profileId
    var userName: String? // userName
    var userEmail: String // userEmail
    var password: String?
    var repeatedPassword: String?

    func validateLogin() throws {
        /// validate email textField entry
        if userEmail.isEmpty {
            throw ValidationError.emailEmpty
        } else {
            if !StringHelper.isEmailValid(userEmail) {
                throw ValidationError.emailEmpty
            }
        }
        /// validate password textField entry
        if let pass = password {
            if pass.isEmpty {
                throw ValidationError.passwordEmpty
            } else {
                if !StringHelper.isPasswordValid(pass) {
                    throw ValidationError.passwordInvalid
                }
            }
        } else {
            throw ValidationError.passwordEmpty
        }
    }

    func validateRegistration() throws {
        /// validate name textField entry
        if let name = userName {
            if name.isEmpty {
                throw ValidationError.nameEmpty
            } else {
                if !StringHelper.isFullNameValid(name) {
                    throw ValidationError.nameInvalid
                }
            }
        } else {
            throw ValidationError.nameEmpty
        }
        /// validate email textField entry
        if userEmail.isEmpty {
            throw ValidationError.emailEmpty
        } else {
            if !StringHelper.isEmailValid(userEmail) {
                throw ValidationError.emailEmpty
            }
        }
        /// validate password textField entry
        if let pass = password {
            if pass.isEmpty {
                throw ValidationError.passwordEmpty
            } else {
                if !StringHelper.isPasswordValid(pass) {
                    throw ValidationError.passwordInvalid
                }
            }
        } else {
            throw ValidationError.passwordEmpty
        }

        /// validate repeatedPassword textField entry
        if let repeatedPass = repeatedPassword {
            if repeatedPass.isEmpty {
                throw ValidationError.repeatPasswordEmpty
            } else {
                if !StringHelper.isPasswordValid(repeatedPass) {
                    throw ValidationError.repeatPasswordInvalid
                }
            }
        } else {
            throw ValidationError.repeatPasswordEmpty
        }
            /// validate does password & repeatedPassword match
        if let pass = password, let repeatedPass = repeatedPassword {
            if !pass.isEmpty && !repeatedPass.isEmpty {
                if !StringHelper.repeatPasswordValidation(pass, repeatedPass) {
                    throw ValidationError.passwordsDontMatch
                }
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
