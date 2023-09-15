//
//  Reminder.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 13.9.23..
//

import Foundation

struct Reminder: Codable {

    var id: Int?
    var title: String
    var description: String
    var important: Bool
    var date: String?

}
