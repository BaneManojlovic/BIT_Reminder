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
    }

    private func setTextFields() {
        /// password titleTextField
        self.titleTextField.textColor = .white
        self.titleTextField.font = UIFont.systemFont(ofSize: 20)
        self.titleTextField.backgroundColor = Asset.textfieldBlueColor.color
        self.titleTextField.layer.cornerRadius = 10
        self.titleTextField.attributedPlaceholder = NSAttributedString(
                                                       string: "title",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])

        self.descriptionTextView.backgroundColor = Asset.textfieldBlueColor.color
        self.descriptionTextView.layer.cornerRadius = 10
        self.descriptionTextView.textColor = .white
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
        self.titleTextField.text = model.title
        if let description = model.description,
           let isImportant = model.important {
            self.descriptionTextView.text = description
            self.setImportanceSwitch.isOn = isImportant
        }
        self.addButton.isEnabled = false
    }
}
