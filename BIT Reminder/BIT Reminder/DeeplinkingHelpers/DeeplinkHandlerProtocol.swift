//
//  DeeplinkHandlerProtocol.swift
//  BIT Reminder
//
//  Created by suncica on 19.7.24..
//

import Foundation

protocol DeeplinkHandlerProtocol {
    func canOpenURL(_ url: URL) -> Bool
    func openURL(_ url: URL)
}

protocol DeeplinkCoordinatorProtocol {
    @discardableResult
    func handleURL(_ url: URL) -> Bool
}

final class DeeplinkCoordinator {

    let handlers: [DeeplinkHandlerProtocol]
    init(handlers: [DeeplinkHandlerProtocol]) {
        self.handlers = handlers
    }
}

extension DeeplinkCoordinator: DeeplinkCoordinatorProtocol {
    @discardableResult
    func handleURL(_ url: URL) -> Bool {
        guard let handler = handlers.first(where: { $0.canOpenURL(url) }) else {
            return false
        }

        handler.openURL(url)
        return true
    }
}
