//
//  AddNewReminderViewPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import Foundation
import KRProgressHUD

protocol AddNewReminderViewPresenterDelegate: AnyObject {
    func addNewReminderFailure(message: String)
    func addNewReminderSuccess()
}

class AddNewReminderViewPresenter {

    weak var delegate: AddNewReminderViewPresenterDelegate?
    var authManager = AuthManager()

    // MARK: - Initialization

    init() { }

    // MARK: - Delegate Methods

    func attachView(view: AddNewReminderViewPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }

    func addNewReminder(model: Reminder) {
        debugPrint("Add ...")
        KRProgressHUD.show()
        Task {
            do {
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
            }
        }
    }
}
