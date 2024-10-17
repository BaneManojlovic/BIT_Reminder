//
//  PasswordErrorType.swift
//  BIT Reminder
//
//  Created by suncica on 21.5.24..
//

import Foundation

enum PasswordErrorType {
    case noLength
    case noLetter
    case noNumber
    case noNumberandLetter
    case noNumberandLength
    case noLetterandLength
    case noAll
    case noError

    var errorMessages: String? {
        switch self {
        case .noLength:
            return L10n.titleLabelPasswordNoLenght
        case .noLetter:
            return L10n.labelTitleErrorNoLetterNewPassword
        case .noNumber:
            return L10n.labelTitleErrorNoNumberNewPassword
        case .noNumberandLetter:
            return L10n.labelTitleErrorNoNumberAndLetterNewPassword
        case .noNumberandLength:
            return L10n.labelTitleErrorNoNumberAndLengthNewPassword
        case .noLetterandLength:
            return L10n.labelTitleErrorNoLetterAndLengthNewPassword
        case .noAll:
            return L10n.labelTitleErrorNoAllNewPassword
        case .noError:
            return nil
        }
    }
}
