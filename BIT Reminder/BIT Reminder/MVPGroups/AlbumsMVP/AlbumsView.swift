//
//  AlbumsView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import UIKit

class AlbumsView: UIView {

    @IBOutlet weak var tableView: UITableView!

    func setupUI() {
        self.backgroundColor = Asset.backgroundBlueColor.color
        self.tableView.backgroundColor = Asset.backgroundBlueColor.color
        self.tableView.register(UINib(nibName: AlbumsTableViewCell.reuseIdentifier, bundle: nil),
                                forCellReuseIdentifier: AlbumsTableViewCell.reuseIdentifier)
    }
}
