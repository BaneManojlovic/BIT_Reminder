//
//  SettingsTableViewCell.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accessoryImage: UIImageView!

    // MARK: - Properties
    static let reuseIdentifier = "SettingsTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupUI()
    }

    func setupUI() {
        self.clipsToBounds = true
        selectionStyle = .none
        self.backgroundColor = Asset.backgroundBlueColor.color
        /// setup title label
        self.titleLabel.textAlignment = .left
        self.titleLabel.textColor = .white
        /// setup image
        self.accessoryImage.image = UIImage(systemName: "chevron.right")?.withTintColor(.white)
    }

    func fillCellData(text: String) {
        self.titleLabel.text = text
        if text == "Delete account" {
            self.titleLabel.textColor = .red
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
