//
//  SettingsView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 13.9.23..
//

import UIKit

class SettingsView: UIView {

    @IBOutlet weak var tableView: UITableView!

    func setupUI() {
        self.backgroundColor = Asset.backgroundBlueColor.color
        self.tableView.backgroundColor = Asset.backgroundBlueColor.color
        self.tableView.register(UINib(nibName: SettingsTableViewCell.reuseIdentifier, bundle: nil),
                                forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier)
    }
}
