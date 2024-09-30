//
//  ReminderTextFieldCalendar.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 11.1.24..
//

import Foundation
import UIKit

class ReminderTextFieldCalendar: BaseTextField {

    var inputDatePicker: UIDatePicker?
    override var placeholder: String? {
        didSet {
                self.attributedPlaceholder = NSAttributedString(
                    string: L10n.labelDate,
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {

        self.rightViewMode = .always
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
        self.backgroundColor = Asset.textfieldBlueColor.color
        self.layer.cornerRadius = 10
        self.isUserInteractionEnabled = true
        self.textColor = .white
    }
}

extension ReminderTextFieldCalendar {

    func addInputViewDatePicker(target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        inputDatePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        inputDatePicker?.datePickerMode = .date
        inputDatePicker?.minimumDate = Date.now

        if #available(iOS 13.4, *) {
            inputDatePicker?.preferredDatePickerStyle = UIDatePickerStyle.wheels
        }
       self.inputView = inputDatePicker

       let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        toolBar.sizeToFit()
        toolBar.isUserInteractionEnabled = true
       let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: NSLocalizedString(L10n.alertButtonTitleCancel, comment: ""), style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: NSLocalizedString(L10n.labelTitleDone, comment: ""), style: .plain, target: target, action: selector)
       toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)

       self.inputAccessoryView = toolBar
    }

      @objc func cancelPressed() {
        self.resignFirstResponder()
      }
}
