//
//  AlbumsTableViewCell.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import UIKit

class AlbumsTableViewCell: UITableViewCell {

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
        /// setup folder imageVoiew
        self.folderImageView.image = UIImage(systemName: "folder")
        /// setup titleLabel
        self.titleLabel.textColor = .white
        self.titleLabel.textAlignment = .left
        /// setup imageCountLabel
        self.imageCountLabel.textColor = .white
        self.imageCountLabel.textAlignment = .left
        /// setup accessory image
        self.accessoryImage.image = UIImage(systemName: "arrow.right")
    }

    func setupCellData(model: Album) {
        self.titleLabel.text = model.title
        self.imageCountLabel.text = "\(model.count)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
