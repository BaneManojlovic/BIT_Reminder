//
//  AddNewReminderView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import UIKit

class AddNewReminderView: UIView {

    // MARK: - Outlets

    @IBOutlet weak var addTitleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var setImportanceLabel: UILabel!
    @IBOutlet weak var setImportanceSwitch: UISwitch!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var setReminderDateLabel: UILabel!
    @IBOutlet weak var datePickerTextField: ReminderTextFieldCalendar!
    @IBOutlet weak var dateValueLabel: UILabel!

    // MARK: - Setup Methods

    func setupUI() {
        self.backgroundColor = Asset.backgroundBlueColor.color
        self.setLabels()
        self.setTextFields()
        self.setSwitch()
        self.setButtons()
    }

    private func setLabels() {
        /// set addTitleLabel
        self.addTitleLabel.textColor = .white
        self.addTitleLabel.textAlignment = .left
        self.addTitleLabel.text = L10n.labelMessageSetReminderTitle
        /// set addDescriptionLabel
        self.addDescriptionLabel.textColor = .white
        self.addDescriptionLabel.textAlignment = .left
        self.addDescriptionLabel.text = L10n.labelMessageSetReminderDescription
        /// set setImportanceLabel
        self.setImportanceLabel.textColor = .white
        self.setImportanceLabel.textAlignment = .left
        self.setImportanceLabel.text = L10n.labelMessageSetReminderImportance
        /// set setReminderDateLabel
        self.setReminderDateLabel.text = L10n.labelMessageSetReminderDate
        self.setReminderDateLabel.textColor = .white
        self.setReminderDateLabel.textAlignment = .left
        /// set dateValueLabel
        self.dateValueLabel.textColor = .white
        self.dateValueLabel.textAlignment = .right
        self.dateValueLabel.isHidden = true
    }

    private func setTextFields() {
        /// set titleTextField
        self.titleTextField.textColor = .white
        self.titleTextField.font = UIFont.systemFont(ofSize: 20)
        self.titleTextField.backgroundColor = Asset.textfieldBlueColor.color
        self.titleTextField.layer.cornerRadius = 10
        self.titleTextField.attributedPlaceholder = NSAttributedString(
            string: L10n.labelTitle,
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        /// set  descriptionTextView
        self.descriptionTextView.backgroundColor = Asset.textfieldBlueColor.color
        self.descriptionTextView.layer.cornerRadius = 10
        self.descriptionTextView.textColor = .white
    }

    private func setSwitch() {
        self.setImportanceSwitch.isOn = false
    }

    private func setButtons() {
        /// setup for add/edit button
        self.addButton.backgroundColor = Asset.buttonBlueColor.color
        self.addButton.setTitle(L10n.labelAdd, for: .normal)
        self.addButton.tintColor = .white
        self.addButton.layer.cornerRadius = 10
        self.addButton.isEnabled = false
    }

    func changeEditButtonStatus(isChanged: Bool) {

        if isChanged {
            self.addButton.isEnabled = true
        } else {
            self.addButton.isEnabled = false
        }
    }

    func setReminderData(model: Reminder) {
        /// Label text when Reminder have values
        self.addTitleLabel.text = L10n.labelTitleWithDots
        self.addDescriptionLabel.text = L10n.labelDescription
        self.setImportanceLabel.text = L10n.labelReminderImportance
        self.setReminderDateLabel.text = L10n.labelReminderDate
        /// Label values from Reminder model
        self.titleTextField.text = model.title
        if let description = model.description,
           let isImportant = model.important {
            self.descriptionTextView.text = description
            self.setImportanceSwitch.isOn = isImportant
        }
        self.datePickerTextField.isHidden = true
        self.datePickerTextField.isUserInteractionEnabled = false
        self.dateValueLabel.isHidden = false
        self.dateValueLabel.text = formatDateToShow(date: model.date ?? "")
        self.addButton.isEnabled = false
        self.titleTextField.isEnabled = false
        self.descriptionTextView.isUserInteractionEnabled = false
        self.setImportanceSwitch.isUserInteractionEnabled = false
        self.addButton.setTitle(L10n.labelTitleEdit, for: .normal)
    }

    func formatDateToShow(date: String) -> String {
        let formatter = DateFormatter()
        /// format String to date
        formatter.dateFormat = "yyyy-MM-dd"
        guard let firstDate = formatter.date(from: date) else { return "" }
        /// reformat date to String
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: firstDate)
    }

}
