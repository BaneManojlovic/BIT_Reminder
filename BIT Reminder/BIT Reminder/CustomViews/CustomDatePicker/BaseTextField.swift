//
//  BaseTextField.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 11.1.24..
//

import UIKit
import Foundation

class BaseTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initilize()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initilize()
    }

    private func initilize() {
        layer.cornerRadius = 10
        placeholder = super.placeholder
        tintColor = super.tintColor
        textColor = .white
        textContentType = .oneTimeCode
        autocorrectionType = .no
        autocapitalizationType = .none
        backgroundColor = Asset.textfieldBlueColor.color
        setupFont()
        setUpVisibility()
    }
    func setupFont() {
        font = UIFont.systemFont(ofSize: 16)
    }
    func setUpVisibility() {
        isSecureTextEntry = false
    }
    override var placeholder: String? {

        didSet {
            if let placeholder = self.placeholder {
                let color = UIColor.white
                let font = UIFont.systemFont(ofSize: 16)
                let placeholderString = NSAttributedString(string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font])
                self.attributedPlaceholder = placeholderString
            }
        }
    }
    func setInsets(forBounds bounds: CGRect) -> CGRect {
            var totalInsets = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
            if let leftView = leftView { totalInsets.left += leftView.frame.origin.x }
            if let rightView = rightView { totalInsets.right += rightView.bounds.size.width }

            return bounds.inset(by: totalInsets)

    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return setInsets(forBounds: bounds)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return setInsets(forBounds: bounds)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return setInsets(forBounds: bounds)
    }
}
