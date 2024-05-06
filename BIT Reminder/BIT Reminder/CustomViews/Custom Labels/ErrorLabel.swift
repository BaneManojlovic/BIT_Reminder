//
//  ErrorLabel.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 16.1.24..
//

import UIKit

class ErrorLabel: UILabel {
    convenience init() {
        self.init(frame: .zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    func setup() {
        textColor = UIColor.systemRed
        backgroundColor = UIColor.clear
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        font = UIFont.systemFont(ofSize: 12)
    }

}
