//
//  InternetErrorHandling.swift
//  BIT Reminder
//
//  Created by suncica on 4.10.24..
//

import Foundation
import SwiftUI

// Global error handling function
func mapErrorToMessage(_ error: Error) -> String {
    if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
        return "The Internet connection appears to be offline"
    } else {
        return "An error occurred: \(error.localizedDescription)"
    }
}

class AlertManager: ObservableObject {

    static let shared = AlertManager()
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    func triggerAlert(for error: Error) {
        self.alertMessage = mapErrorToMessage(error)
        self.showAlert = true
    }
}
