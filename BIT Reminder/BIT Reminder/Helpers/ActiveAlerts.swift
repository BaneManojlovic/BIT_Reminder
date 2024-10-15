//
//  ActiveAlerts.swift
//  BIT Reminder
//
//  Created by suncica on 28.9.24..
//

import Foundation

enum ActiveAlert: Identifiable {
    case deleteConfirmation
    case profileUpdate
    case generalAlert

    // Conforming to Identifiable
    var id: Int {
        switch self {
        case .deleteConfirmation: return 0
        case .profileUpdate: return 1
        case .generalAlert: return 2
        }
    }
}

