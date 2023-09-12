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

    func setUser(user: User) {
        do {
            let userData = try JSONEncoder().encode(user)
            UserDefaults.standard.set(userData, forKey: UserDefaultKeys.user.rawValue)
            UserDefaults.standard.synchronize()
        } catch {
            debugPrint(error)
        }
    }

    func getUser() -> User? {
        do {
            guard let userData = UserDefaults.standard.data(forKey: UserDefaultKeys.user.rawValue) else {
                return nil
            }
            let user = try JSONDecoder().decode(User.self, from: userData)
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
}
