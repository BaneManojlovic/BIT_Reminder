//
//  AddNewReminderViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import UIKit

class AddNewReminderViewController: BaseNavigationController {

    var presenter: AddNewReminderViewPresenter?

    var choosenDate: Date?
    var isEditingModeOn = false
    var titleHasChanged = false
    var descriptionHasChanged = false
    var importanceHasChanged = false
    var dateHasChanged = false

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
            self.haveEditAndDeleteButton = true
            self.title = L10n.titleLabelReminderDetails
            self.addNewReminderView.setReminderData(model: model)
        } else {
            self.haveEditAndDeleteButton = false
            self.title = L10n.titleLabelAddNewReminder
        }
    }

    private func setupDelegates() {
        self.presenter?.attachView(view: self)
        self.addNewReminderView.titleTextField.delegate = self
        self.addNewReminderView.descriptionTextView.delegate = self
    }

    private func setupTargets() {
        if presenter?.screenType == .reminderDetailsScreen {
            self.addNewReminderView.addButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
            self.addNewReminderView.setImportanceSwitch.addTarget(self, action: #selector(switchStateChanged(_:)), for: .valueChanged)
        } else {
            self.addNewReminderView.addButton.addTarget(self, action: #selector(addNewTapped), for: .touchUpInside)
        }

        self.addNewReminderView.titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    func setupDatePicker() {
        self.addNewReminderView.datePickerTextField.addInputViewDatePicker(target: self, selector: #selector((selectReminderDate)))
        self.addNewReminderView.datePickerTextField.inputDatePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: UIControl.Event.valueChanged)
    }
    
    @objc func switchStateChanged(_ sender: UISwitch) {
        if sender.isOn {
            self.importanceHasChanged = false
            debugPrint("Switch is not changed")
        } else {
            self.importanceHasChanged = true
            debugPrint("Switch is changed")
        }
        self.addNewReminderView.changeEditButtonStatus(isChanged: dateHasChanged || importanceHasChanged || titleHasChanged || descriptionHasChanged)
    }

    @objc func selectReminderDate() {
        if let  datePicker = self.addNewReminderView.datePickerTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none

            let selectedDateFormatter = DateFormatter()
            selectedDateFormatter.dateFormat = "dd.MM.yyyy" // The format of selectedDate
            let selectedDate = selectedDateFormatter.string(from: choosenDate ?? Date())

            let initialRequestDayFormatter = DateFormatter()
            initialRequestDayFormatter.dateFormat = "yyyy-MM-dd" // The format of initialRequestDay
            let initialRequestDay = presenter?.model?.date ?? ""

            if let selectedDateObject = selectedDateFormatter.date(from: selectedDate),
               let initialRequestDayObject = initialRequestDayFormatter.date(from: initialRequestDay) {
                // Compare the Date objects
                if presenter?.screenType == .reminderDetailsScreen {

                    if selectedDateObject == initialRequestDayObject {
                        self.dateHasChanged = false
                        debugPrint("The dates are the same.")
                    } else {
                        dateHasChanged = true
                        debugPrint("The dates are different.")
                    }
                self.addNewReminderView.changeEditButtonStatus(isChanged: titleHasChanged || descriptionHasChanged || importanceHasChanged || dateHasChanged)
                } else {
                    debugPrint("One or both of the date strings are invalid.")
                }

                }

            self.addNewReminderView.datePickerTextField.text = dateFormatter.string(from: datePicker.date)
        }

        self.addNewReminderView.datePickerTextField.resignFirstResponder()
        self.choosenDate = self.addNewReminderView.datePickerTextField.inputDatePicker?.date
    }

    @objc func dateChanged(datePicker: UIDatePicker) {

        self.addNewReminderView.datePickerTextField.text = formatDate(date: datePicker.date)
        self.addNewReminderView.dateValueLabel.text = formatDate(date: datePicker.date)
        let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
        // Update the label with the selected date
        self.choosenDate = self.addNewReminderView.datePickerTextField.inputDatePicker?.date
        self.addNewReminderView.dateValueLabel.text = "\(formatter.string(from: datePicker.date))"
    }

    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
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

    @objc func editTapped() {
        guard let user = self.presenter?.user else { return }

        if let title = self.addNewReminderView.titleTextField.text,
           let description = self.addNewReminderView.descriptionTextView.text {
            let isImportant = self.addNewReminderView.setImportanceSwitch.isOn
            let model = Reminder(id: presenter?.model?.id,
                                            profileId: user.profileId,
                                             title: title,
                                             description: description,
                                             important: isImportant,
                                             date: self.choosenDate?.ISO8601Format())
            self.presenter?.editReminder(model: model)
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

    override func editAction() {
        super.editAction()
        isEditingModeOn.toggle()
        if isEditingModeOn {
            self.addNewReminderView.titleTextField.isEnabled = true
            self.addNewReminderView.descriptionTextView.isUserInteractionEnabled = true
            self.addNewReminderView.setImportanceSwitch.isUserInteractionEnabled = true
            self.addNewReminderView.datePickerTextField.isUserInteractionEnabled = true
            self.shouldChangeEditButtonColor = true
            self.setEditAndDeleteButton()

        } else {
            self.addNewReminderView.titleTextField.isEnabled = false
            self.addNewReminderView.descriptionTextView.isUserInteractionEnabled = false
            self.addNewReminderView.setImportanceSwitch.isUserInteractionEnabled = false
            self.addNewReminderView.datePickerTextField.isUserInteractionEnabled = false
            self.shouldChangeEditButtonColor = false
            self.setEditAndDeleteButton()
    }

    }
}

// MARK: - Conforming to AddNewReminderViewPresenterDelegate

extension AddNewReminderViewController: AddNewReminderViewPresenterDelegate {
    func editReminderFailure(message: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: message)
        }
    }

    func editReminderSuccess() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.showOkAlert(message: "Reminder successfully edited", confirmation: {
                self.navigationController?.popViewController(animated: true)
            }, completion: nil)
        }
    }

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

// MARK: conforming to UITextFieldDelegate

extension AddNewReminderViewController: UITextFieldDelegate {

    @objc func textFieldDidChange(_ textField: UITextField) {
        let isTextEmpty = addNewReminderView.titleTextField.text?.isEmpty ?? true
        self.addNewReminderView.addButton.isEnabled = !isTextEmpty

        guard let reminderModel = presenter?.model
        else { return }
        let text = textField.text

        if reminderModel.title == text {
            self.titleHasChanged = false
            debugPrint("Title is the same")
        } else {
            self.titleHasChanged = true
            debugPrint("Title is different")
        }

        self.addNewReminderView.changeEditButtonStatus(isChanged: titleHasChanged || descriptionHasChanged || importanceHasChanged || dateHasChanged)
    }
}

// MARK: Conforming to UITextViewDelegate

extension AddNewReminderViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let reminderModel = presenter?.model
        else { return }
        let text = textView.text

        if reminderModel.description == text {
            self.descriptionHasChanged = false
            debugPrint("Description is the same")
        } else {
            self.descriptionHasChanged = true
            debugPrint("Description is different")
        }
        self.addNewReminderView.changeEditButtonStatus(isChanged: titleHasChanged || descriptionHasChanged || importanceHasChanged || dateHasChanged)
    }
}
