//
//  AlbumsTableViewCell.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import UIKit

class AlbumsTableViewCell: UITableViewCell {

    @IBOutlet weak var roundedBackgroundView: UIView!
    @IBOutlet weak var folderImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageCountLabel: UILabel!
    @IBOutlet weak var accessoryImage: UIImageView!

    // MARK: - Properties
    static let reuseIdentifier = "AlbumsTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupUI()
    }

    private func setupUI() {
        self.clipsToBounds = true
        selectionStyle = .none
        self.backgroundColor = Asset.backgroundBlueColor.color
        /// setup roundedBackgroundView
        self.roundedBackgroundView.backgroundColor  =  Asset.tableviewCellBlueColor.color
        self.roundedBackgroundView.layer.cornerRadius = 10
        /// setup folder imageView
        self.folderImageView.image = UIImage(systemName: "folder.fill")
        self.folderImageView.tintColor = .white
        /// setup titleLabel
        self.titleLabel.textColor = .white
        self.titleLabel.textAlignment = .left
        /// setup imageCountLabel
        self.imageCountLabel.textColor = .white
        self.imageCountLabel.textAlignment = .left
        /// setup accessory image
        self.accessoryImage.image = UIImage(systemName: "chevron.right")
        self.accessoryImage.tintColor = .white
    }

    func setupCellData(model: Album) {
        self.titleLabel.text = model.albumName
//        self.imageCountLabel.text = "\(model.count)" + " " + "images"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
