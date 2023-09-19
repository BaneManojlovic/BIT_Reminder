//
//  HomeView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 7.9.23..
//

import UIKit

class HomeView: UIView {

    // MARK: - Outlets

    @IBOutlet weak var homeMessageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Setup Methods

    func setupUI() {
        self.backgroundColor = Asset.backgroundBlueColor.color
        /// setup for tableView
        self.tableView.backgroundColor = Asset.backgroundBlueColor.color
        self.tableView.separatorColor = Asset.backgroundBlueColor.color
        self.tableView.register(UINib(nibName: ReminderTableViewCell.reuseIdentifier, bundle: nil),
                                forCellReuseIdentifier: ReminderTableViewCell.reuseIdentifier)
        /// setup for homeMessageLabel
        self.homeMessageLabel.text = "No Reminders"
        self.homeMessageLabel.textColor = .white
        self.homeMessageLabel.textAlignment = .center
        
    }

}
