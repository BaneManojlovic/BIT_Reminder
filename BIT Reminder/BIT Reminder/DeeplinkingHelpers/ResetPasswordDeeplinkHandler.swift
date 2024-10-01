//
//  RessetPasswordDeeplinkHandler.swift
//  BIT Reminder
//
//  Created by suncica on 19.7.24..
//

import Foundation
import UIKit
import SwiftUI

final class ResetPasswordDeeplinkHandler: DeeplinkHandlerProtocol {

    var userDefaultsHelper = UserDefaultsHelper()

    private weak var rootViewController: UIViewController?
    init(rootViewController: UIViewController?) {
        self.rootViewController = rootViewController
    }

    // MARK: - DeeplinkHandlerProtocol

    func canOpenURL(_ url: URL) -> Bool {
        // cheking for custom scheme and host in info plist
        return url.scheme == "bitreminder" && url.host == "resetpassword"
    }

    func openURL(_ url: URL) {
        guard canOpenURL(url) else {
            return
        }
        let fragment = URLComponents(string: url.absoluteString)?.fragment
        let queryItems = fragment?.components(separatedBy: "&").reduce(into: [String: String]()) { dict, param in
            let pair = param.components(separatedBy: "=")
            if pair.count == 2 {
                dict[pair[0]] = pair[1]
            }
        }
        if let accessToken = queryItems?["access_token"], let refreshToken = queryItems?["refresh_token"] {
            debugPrint("Access Token: \(accessToken)")
            debugPrint("Refresh Token: \(refreshToken)")

            let userDefaults = UserDefaultsHelper()
            userDefaults.saveAccessToken(accessToken)
            userDefaults.saveRefreshToken(refreshToken)

            // passing the tokens to the ChangePasswordView
            let changePasswordView = ChangePasswordView(accessToken: accessToken, refreshToken: refreshToken)
            let hostingController = UIHostingController(rootView: changePasswordView)

            if let navigationController = rootViewController as? UINavigationController {
                navigationController.pushViewController(hostingController, animated: true)
            } else {
                rootViewController?.present(hostingController, animated: true, completion: nil)
            }
        }
    }
}
