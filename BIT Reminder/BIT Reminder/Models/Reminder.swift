//
//  Reminder.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 13.9.23..
//

import Foundation

struct Reminder: Codable {

    var id: Int?
    var profileId: String
    var title: String
    var description: String?
    var important: Bool?
    var date: String?

    func validation() throws {
        /// validate title etxtField
        if title.isEmpty {
            throw ValidationError.titleEmpty
        }
    }

    enum ValidationError: Error {
        case titleEmpty
    }
}

struct ReminderRequestModel: Codable {
    var id: Int?
    var profileId: String
    var title: String
    var description: String?
    var important: Bool?
    var date: String?

    func validation() throws {
        /// validate title etxtField
        if title.isEmpty {
            throw ValidationError.titleEmpty
        }
    }

    enum ValidationError: Error {
        case titleEmpty
    }
}
