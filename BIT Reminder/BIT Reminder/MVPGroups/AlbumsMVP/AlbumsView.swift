//
//  AlbumsView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import UIKit

class AlbumsView: UIView {

    // MARK: - Outlets

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Setup Methods

    func setupUI() {
        self.backgroundColor = Asset.backgroundBlueColor.color
        /// setup for tableView
        self.tableView.backgroundColor = Asset.backgroundBlueColor.color
        self.tableView.register(UINib(nibName: AlbumsTableViewCell.reuseIdentifier, bundle: nil),
                                forCellReuseIdentifier: AlbumsTableViewCell.reuseIdentifier)
        /// setup for messageLabel
        self.messageLabel.text = L10n.labelMessageNoAlbums
        self.messageLabel.textColor = .white
        self.messageLabel.textAlignment = .center
    }
}
