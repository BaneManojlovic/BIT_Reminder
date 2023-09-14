//
//  SettingsView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 13.9.23..
//

import UIKit

class SettingsView: UIView {
    
    @IBOutlet weak var logoutButton: UIButton!

    func setupUI() {
        self.backgroundColor = Asset.backgroundBlueColor.color
        self.setupButtons()
    }

    private func setupButtons() {
        self.logoutButton.backgroundColor = Asset.buttonBlueColor.color
        self.logoutButton.setTitle("Logout", for: .normal)
        self.logoutButton.tintColor = .white
        self.logoutButton.layer.cornerRadius = 10
    }
}
