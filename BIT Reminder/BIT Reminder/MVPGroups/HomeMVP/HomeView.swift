//
//  HomeView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 7.9.23..
//

import UIKit

class HomeView: UIView {

    @IBOutlet weak var homeMessageLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!

    func setupUI() {
        self.backgroundColor = .yellow
        self.setupButtons()
    }

    private func setupButtons() {
        self.logoutButton.backgroundColor = Asset.buttonBlueColor.color
        self.logoutButton.setTitle("Logout", for: .normal)
        self.logoutButton.tintColor = .white
        self.logoutButton.layer.cornerRadius = 10
    }
}
