//
//  FavoriteLocationsTableViewCell.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 19.9.23..
//

import UIKit

class FavoriteLocationsTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var loactionPinImageView: UIImageView!

    // MARK: - Properties
    static let reuseIdentifier = "FavoriteLocationsTableViewCell"

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupUI()
    }

    // MARK: - Setup Methods

    private func setupUI() {
        self.backgroundColor = Asset.backgroundBlueColor.color
        self.selectionStyle = .none

        /// setup titleLabel
        self.locationTitleLabel.textColor = .white
        self.locationTitleLabel.textAlignment = .left
        /// setup accessory image
        self.loactionPinImageView.image = UIImage(systemName: "mappin")
        self.loactionPinImageView.tintColor = .red
    }

    func setupCellData(model: String) {
        self.locationTitleLabel.text = model
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
