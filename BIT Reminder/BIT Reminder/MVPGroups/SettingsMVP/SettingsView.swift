//
//  SettingsView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 13.9.23..
//

import UIKit

class SettingsView: UIView {

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Setup Methods

    func setupUI() {
        self.backgroundColor = Asset.backgroundBlueColor.color
        /// setup for tableView
        self.tableView.backgroundColor = Asset.backgroundBlueColor.color
        self.tableView.register(UINib(nibName: SettingsTableViewCell.reuseIdentifier, bundle: nil),
                                forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier)
    }
}
