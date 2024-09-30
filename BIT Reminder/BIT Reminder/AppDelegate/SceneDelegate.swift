//
//  SceneDelegate.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 3.9.23..
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var userDefaultsHelper = UserDefaultsHelper()
    lazy var deeplinkCoordinator: DeeplinkCoordinatorProtocol = {
           return DeeplinkCoordinator(handlers: [
               ResetPasswordDeeplinkHandler(rootViewController: self.rootViewController)
           ])
       }()

       var rootViewController: UIViewController? {
           return window?.rootViewController
       }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let firstUrl = URLContexts.first?.url else {
            return
        }
        // Extract fragment and create a dictionary of query items
        if let fragment = URLComponents(url: firstUrl, resolvingAgainstBaseURL: false)?.fragment {
            let queryItems = fragment
                .split(separator: "&")
                .map { $0.split(separator: "=") }
                .reduce(into: [String: String]()) { dict, pair in
                    if pair.count == 2 {
                        dict[String(pair[0])] = String(pair[1])
                    }
                }

            let token = queryItems["access_token"]
            let refreshToken = queryItems["refresh_token"]
            
            if let token = token {
                debugPrint("Access Token: \(token)")
                userDefaultsHelper.saveAccessToken(token) // save access token to user defaults
            } else {
                debugPrint("Access Token is nil")
            }
            
            if let refreshToken = refreshToken {
                debugPrint("Refresh Token: \(refreshToken)")
                userDefaultsHelper.saveRefreshToken(refreshToken) // save refresh token to user defaults
            } else {
                debugPrint("Refresh Token is nil")
            }
        } else {
            debugPrint("No fragment found in the URL")
        }
        
        deeplinkCoordinator.handleURL(firstUrl)
    }

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the
        // UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically
        // be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session
        // are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let appDel = (UIApplication.shared.delegate as? AppDelegate)
        appDel?.window = window
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not
        // necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
