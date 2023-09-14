//
//  HomeView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 7.9.23..
//

import UIKit

class HomeView: UIView {

    // TODO: - Set label for no data case
//    @IBOutlet weak var homeMessageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    func setupUI() {
        self.backgroundColor = Asset.backgroundBlueColor.color
        self.tableView.backgroundColor = Asset.backgroundBlueColor.color
        self.tableView.register(UINib(nibName: ReminderTableViewCell.reuseIdentifier, bundle: nil),
                                forCellReuseIdentifier: ReminderTableViewCell.reuseIdentifier)
    }

}
