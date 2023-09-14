//
//  AddNewReminderViewPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import Foundation

protocol AddNewReminderViewPresenterDelegate: AnyObject {

}

class AddNewReminderViewPresenter {

    weak var delegate: AddNewReminderViewPresenterDelegate?

    // MARK: - Initialization

    init() { }

    // MARK: - Delegate Methods

    func attachView(view: AddNewReminderViewPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }

    func addNewReminder() {
        debugPrint("Add ...")
    }
}
