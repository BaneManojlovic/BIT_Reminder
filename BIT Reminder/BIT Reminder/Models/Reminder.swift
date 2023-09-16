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
    
    // TODO: - Create validation for Add Reminder Scrren & Reminder model
    // title is mandatory, all the others are not
}
