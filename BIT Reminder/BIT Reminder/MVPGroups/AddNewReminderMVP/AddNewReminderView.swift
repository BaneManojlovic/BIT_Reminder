//
//  AddNewReminderView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import UIKit

class AddNewReminderView: UIView {

    @IBOutlet weak var addTitleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var setImportanceLabel: UILabel!
    @IBOutlet weak var setImportanceSwitch: UISwitch!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var setReminderDateLabel: UILabel!
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBOutlet weak var dateValueLabel: UILabel!

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
        self.addTitleLabel.text = "Set Reminder title:"
        /// set addDescriptionLabel
        self.addDescriptionLabel.textColor = .white
        self.addDescriptionLabel.textAlignment = .left
        self.addDescriptionLabel.text = "Set Reminder description:"
        /// set setImportanceLabel
        self.setImportanceLabel.textColor = .white
        self.setImportanceLabel.textAlignment = .left
        self.setImportanceLabel.text = "Set Reminder importance:"
        /// set setReminderDateLabel
        self.setReminderDateLabel.text = "Set Reminder date:"
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
                                                       string: "title",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        /// set  descriptionTextView
        self.descriptionTextView.backgroundColor = Asset.textfieldBlueColor.color
        self.descriptionTextView.layer.cornerRadius = 10
        self.descriptionTextView.textColor = .white
        /// set titleTextField
        self.datePickerTextField.textColor = .white
        self.datePickerTextField.font = UIFont.systemFont(ofSize: 20)
        self.datePickerTextField.backgroundColor = Asset.textfieldBlueColor.color
        self.datePickerTextField.layer.cornerRadius = 10
        self.datePickerTextField.isHidden = false
        self.datePickerTextField.attributedPlaceholder = NSAttributedString(
                                                       string: "date",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }

    private func setSwitch() {
        self.setImportanceSwitch.isOn = false
    }

    private func setButtons() {
        /// setup for login button
        self.addButton.backgroundColor = Asset.buttonBlueColor.color
        self.addButton.setTitle("Add", for: .normal)
        self.addButton.tintColor = .white
        self.addButton.layer.cornerRadius = 10
    }

    func setReminderData(model: Reminder) {
        /// Label text when Reminder have values
        self.addTitleLabel.text = "Title:"
        self.addDescriptionLabel.text = "Description:"
        self.setImportanceLabel.text = "Reminder importance:"
        self.setReminderDateLabel.text = "Reminder date:"
        /// Label values from Reminder model
        self.titleTextField.text = model.title
        if let description = model.description,
           let isImportant = model.important {
            self.descriptionTextView.text = description
            self.setImportanceSwitch.isOn = isImportant
        }
        self.datePickerTextField.isHidden = true
        self.dateValueLabel.isHidden = false
        self.dateValueLabel.text = formatDateToShow(date: model.date ?? "")
        self.addButton.isEnabled = false
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
