//
//  AddNewReminderViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import UIKit

class AddNewReminderViewController: BaseNavigationController {

    var presenter: AddNewReminderViewPresenter?
    let datePicker = UIDatePicker()
    var choosenDate: Date?

    private var addNewReminderView: AddNewReminderView! {
        loadViewIfNeeded()
        return view as? AddNewReminderView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupDelegates()
        self.setupTargets()
        self.setupDatePicker()
    }

    private func setupUI() {
        self.addNewReminderView.setupUI()
        self.haveBackButton = true
        if let screenType = self.presenter?.screenType,
           let model = self.presenter?.model,
            screenType == .reminderDetailsScreen {
            self.haveDeleteButton = true
            self.title = L10n.titleLabelReminderDetails
            self.addNewReminderView.setReminderData(model: model)
        } else {
            self.haveDeleteButton = false
            self.title = L10n.titleLabelAddNewReminder
        }
    }

    private func setupDelegates() {
        self.presenter?.attachView(view: self)
    }

    private func setupTargets() {
        self.addNewReminderView.addButton.addTarget(self, action: #selector(addNewTapped), for: .touchUpInside)
    }

    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date.now
        self.addNewReminderView.datePickerTextField.inputView = datePicker
    }

    @objc func dateChanged(datePicker: UIDatePicker) {
        self.addNewReminderView.datePickerTextField.text = formatDate(date: datePicker.date)
        self.choosenDate = datePicker.date
    }

    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }

    @objc func addNewTapped() {
        guard let user = self.presenter?.user else { return }

        if let title = self.addNewReminderView.titleTextField.text,
           let description = self.addNewReminderView.descriptionTextView.text {
            let isImportant = self.addNewReminderView.setImportanceSwitch.isOn
            let model = ReminderRequestModel(profileId: user.profileId,
                                             title: title,
                                             description: description,
                                             important: isImportant,
                                             date: self.choosenDate?.ISO8601Format())
            self.presenter?.addNewReminder(model: model)
        }
    }

    override func deleteAction() {
        super.deleteAction()
        self.showCancelOrYesAlert(message: L10n.labelMessageSureWantDeleteReminder,
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
            self.showValidationError(message: L10n.labelErrorTitleEmpty)
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
            self.showOkAlert(message: L10n.labelMessageNewReminderAdded, confirmation: {
                self.navigationController?.popViewController(animated: true)
            }, completion: nil)
        }
    }
}
