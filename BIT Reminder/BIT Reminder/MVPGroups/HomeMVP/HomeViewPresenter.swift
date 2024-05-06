//
//  HomeViewPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 7.9.23..
//

import Foundation
import Supabase
import KRProgressHUD

protocol HomeViewPresenterDelegate: AnyObject {
    func getRemindersFailure(error: String)
    func getRemindersSuccess(response: [Reminder])
    func deleteReminderFailure(message: String)
    func deleteReminderSuccess()
}

class HomeViewPresenter {

    // MARK: - Properties

    weak var delegate: HomeViewPresenterDelegate?
    var authManager = AuthManager()
    let userDefaults = UserDefaultsHelper()
    var userEmail: String?
    var screenName: String?
    var reminders: [Reminder] = []
    var filteredReminders: [Reminder] = []
    var sortedReminders: [Reminder] = []

    // MARK: - Initialization

    init() { }

    // MARK: - Delegate Methods

    func attachView(view: HomeViewPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }

    func getReminders() {
        self.reminders = []
        KRProgressHUD.show()
        Task {
            do {
                try await self.authManager.getReminders { error, response  in
                    if let error = error {
                        debugPrint(error)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                           KRProgressHUD.dismiss()
                        }
                        self.delegate?.getRemindersFailure(error: error.localizedDescription)
                    } else {
                        debugPrint("")
                        KRProgressHUD.dismiss()
                        if let resp = response {
                            debugPrint(resp)
                            self.reminders = resp
                            self.delegate?.getRemindersSuccess(response: resp)
                        }
                    }
                }
            }
        }
    }

    func deleteReminder(model: Reminder) {
        KRProgressHUD.show()
        Task {
            do {
                try await self.authManager.deleteReminder(model: model) { error in
                    if let error = error {
                        debugPrint(error)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                           KRProgressHUD.dismiss()
                        }
                        self.delegate?.deleteReminderFailure(message: error.localizedDescription)
                    } else {
                        debugPrint("")
                        KRProgressHUD.dismiss()
                        self.delegate?.deleteReminderSuccess()
                    }
                }
            }
        }
    }
}
