//
//  NameTextFieldView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 20.1.24..
//

import UIKit

class NameTextFieldView: BaseInputTextFieldView {
    
    @objc override func textFieldDidChange(_ textField: UITextField) {
        let isValid = EmailAndPasswordValidation.isFullNameValid(textField: inputTextField)
        if textField.text?.isEmpty == true {
            setUpNoErrorView()
            isError = true
        } else {
            if isValid == false {
                errorLabel.text = L10n.labelErrorMessageNameInvalidFormat
                setUpErrorView()
                if textField.text?.isEmpty == true {
                    setUpNoErrorView()
                }
            } else {
                setUpNoErrorView()
            }
        }
    }
    override func textFieldDidBeginEditing(_ textField: UITextField) {
       setUpNoErrorView()
    }
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       return true
    }

    func setUpErrorView() {
        errorLabel.isHidden = false
        isError = true
        errorLabel.textColor = UIColor.systemRed
        inputTextField.layer.borderWidth = 2
        inputTextField.layer.borderColor = UIColor.systemRed.cgColor
    }
    
    func setUpNoErrorView() {
        isError = false
        errorLabel.isHidden = true
        inputTextField.layer.borderWidth = 0
    }
}
