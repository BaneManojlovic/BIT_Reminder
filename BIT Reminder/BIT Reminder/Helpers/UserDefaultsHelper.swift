//
//  UserDefaultsHelper.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 12.9.23..
//

import Foundation

enum UserDefaultKeys: String {
    case user
}

class UserDefaultsHelper {
    
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"

    func setUser(user: UserModel) {
        do {
            let userData = try JSONEncoder().encode(user)
            UserDefaults.standard.set(userData, forKey: UserDefaultKeys.user.rawValue)
            UserDefaults.standard.synchronize()
        } catch {
            debugPrint(error)
        }
    }

    func getUser() -> UserModel? {
        do {
            guard let userData = UserDefaults.standard.data(forKey: UserDefaultKeys.user.rawValue) else {
                return nil
            }
            let user = try JSONDecoder().decode(UserModel.self, from: userData)
            return user
        } catch {
            debugPrint(error)
            return nil
        }
    }

    func removeUser() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.user.rawValue)
    }

    func emptyUserDefaults() {
        self.removeUser()

        UserDefaults.standard.synchronize()
    }

// MARK: methods for saving and retreving tokens after reseting users password
    
    func saveAccessToken(_ token: String) {
         UserDefaults.standard.set(token, forKey: accessTokenKey)
     }

     func getAccessToken() -> String? {
         return UserDefaults.standard.string(forKey: accessTokenKey)
     }

     func saveRefreshToken(_ token: String) {
         UserDefaults.standard.set(token, forKey: refreshTokenKey)
     }

     func getRefreshToken() -> String? {
         return UserDefaults.standard.string(forKey: refreshTokenKey)
     }
    
    func removeTokens() {
         UserDefaults.standard.removeObject(forKey: accessTokenKey)
         UserDefaults.standard.removeObject(forKey: refreshTokenKey)
     }
}
