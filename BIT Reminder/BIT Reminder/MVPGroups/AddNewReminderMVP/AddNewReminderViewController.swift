//
//  AddNewReminderViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import UIKit

class AddNewReminderViewController: BaseNavigationController {

    var presenter: AddNewReminderViewPresenter?

    private var addNewReminderView: AddNewReminderView! {
        loadViewIfNeeded()
        return view as? AddNewReminderView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()

        self.setupDelegates()
        self.setupTargets()
    }

    private func setupUI() {
        self.addNewReminderView.setupUI()

        self.haveBackButton = true
        if let screenType = self.presenter?.screenType,
           let model = self.presenter?.model,
            screenType == .reminderDetailsScreen {
            self.haveDeleteButton = true
            self.title = "Reminder Details"
            self.addNewReminderView.setReminderData(model: model)
        } else {
            self.haveDeleteButton = false
            self.title = "Add New Reminder"
        }
    }

    private func setupDelegates() {
        self.presenter?.attachView(view: self)
    }

    private func setupTargets() {
        self.addNewReminderView.addButton.addTarget(self, action: #selector(addNewTapped), for: .touchUpInside)
    }

    @objc func addNewTapped() {
        guard let user = self.presenter?.user else { return }

        if let title = self.addNewReminderView.titleTextField.text,
           let description = self.addNewReminderView.descriptionTextView.text {
            let isImportant = self.addNewReminderView.setImportanceSwitch.isOn

            let model = Reminder(profileId: user.profileId,
                                 title: title,
                                 description: description,
                                 important: isImportant,
                                 date: nil)
            self.presenter?.addNewReminder(model: model)
        }
    }

    override func deleteAction() {
        super.deleteAction()
        self.showCancelOrYesAlert(message: "Are you sure that you want to delete this Reminder?",
                                  yesHandler: {
            if let model = self.presenter?.model {
                self.presenter?.deleteReminder(model: model)
            }
        })
    }
}

// MARK: - Conforming to AddNewReminderViewPresenterDelegate

extension AddNewReminderViewController: AddNewReminderViewPresenterDelegate {

    func deleteReminderFailure(message: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: message)
        }
    }

    func deleteReminderSuccess() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }

    func handleValidationError(error: Reminder.ValidationError) {
        switch error {
        case .titleEmpty:
            self.showValidationError(message: "titleEmpty")
        }
    }

    func showValidationError(message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.showOkAlert(message: message)
        }
    }

    func addNewReminderFailure(message: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: message)
        }
    }

    func addNewReminderSuccess() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.showOkAlert(message: "New Reminder successfully added!", confirmation: {
                self.navigationController?.popViewController(animated: true)
            }, completion: nil)
        }
    }
}
