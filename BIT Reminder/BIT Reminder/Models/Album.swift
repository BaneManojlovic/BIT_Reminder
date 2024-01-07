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

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case albumName = "album_name"
        case profileId = "profile_id"
    }
}

struct Photo: Codable {
    var id: Int?
    var path: String
    var albumId: Int

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case path = "path"
        case albumId = "album_id"
    }
}
