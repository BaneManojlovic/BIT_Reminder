//
//  Album.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import Foundation

struct Album: Codable {
    var id: Int?
    var albumName: String
    var profileId: String
}

struct Photo: Codable {
    var id: Int?
    var path: String
    var albumId: Int
}
