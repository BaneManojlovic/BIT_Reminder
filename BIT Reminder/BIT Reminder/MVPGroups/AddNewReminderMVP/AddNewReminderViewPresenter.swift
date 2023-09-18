//
//  AddNewReminderViewPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import Foundation
import KRProgressHUD

enum ReminderScreenType {
    case addNewReminderScreen
    case reminderDetailsScreen
}

protocol AddNewReminderViewPresenterDelegate: AnyObject {
    func addNewReminderFailure(message: String)
    func addNewReminderSuccess()
    func handleValidationError(error: Reminder.ValidationError)
    func deleteReminderFailure(message: String)
    func deleteReminderSuccess()
}

class AddNewReminderViewPresenter {

    weak var delegate: AddNewReminderViewPresenterDelegate?
    var authManager = AuthManager()
    var userDefaultsHelper = UserDefaultsHelper()
    var user: UserModel?
    var model: Reminder?
    var screenType: ReminderScreenType?

    // MARK: - Initialization

    init(screenType: ReminderScreenType, model: Reminder?) {
        self.screenType = screenType
        self.model = model
        self.user = self.userDefaultsHelper.getUser()
    }

    // MARK: - Delegate Methods

    func attachView(view: AddNewReminderViewPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }

    func addNewReminder(model: Reminder) {
        KRProgressHUD.show()
        Task {
            do {
                try model.validation()
                try await self.authManager.addNewReminder(model: model) { error, response in
                    if let error = error {
                        debugPrint(error)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                           KRProgressHUD.dismiss()
                        }
                        self.delegate?.addNewReminderFailure(message: error.localizedDescription)
                    } else if let resp = response {
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                           KRProgressHUD.dismiss()
                        }
                        self.delegate?.addNewReminderSuccess()
                    }
                }
            } catch let error as Reminder.ValidationError {
                DispatchQueue.main.async {
                   KRProgressHUD.dismiss()
                }
                self.delegate?.handleValidationError(error: error)
            }
        }
    }
    
    func deleteReminder(model: Reminder) {
        // TODO: - to be implemented
        debugPrint("delete delete ...")
        let table = "reminders"
        KRProgressHUD.show()
        Task {
            do {
                try await self.authManager.deleteReminder(tableName: table, model: model) { error in
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
