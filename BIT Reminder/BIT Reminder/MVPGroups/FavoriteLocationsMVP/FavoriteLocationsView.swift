//
//  FavoriteLocationsView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 19.9.23..
//

import UIKit

class FavoriteLocationsView: UIView {

    // MARK: - Outlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!

    // MARK: - Setup Methods

    func setupUI() {
        self.backgroundColor = Asset.backgroundBlueColor.color
        self.titleLabel.textColor = .white
        self.titleLabel.text = L10n.titleLabelFavoriteLocations
        self.titleLabel.textAlignment = .center
        self.tableView.backgroundColor = Asset.backgroundBlueColor.color
        self.tableView.register(UINib(nibName: FavoriteLocationsTableViewCell.reuseIdentifier, bundle: nil),
                                forCellReuseIdentifier: FavoriteLocationsTableViewCell.reuseIdentifier)
        self.setupCloseButton()
    }

    private func setupCloseButton() {
        self.closeButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        self.closeButton.tintColor = .white
    }
}
