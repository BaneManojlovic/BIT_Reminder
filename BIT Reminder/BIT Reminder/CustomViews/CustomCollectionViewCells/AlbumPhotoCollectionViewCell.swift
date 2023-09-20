//
//  AlbumPhotoCollectionViewCell.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 18.9.23..
//

import UIKit

class AlbumPhotoCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets

    @IBOutlet weak var cellImage: UIImageView!

    // MARK: - Properties

    static let cellIdentifier = "AlbumPhotoCollectionViewCell"

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupUI()
    }

    // MARK: - Setup Methods

    func setupUI() {
        self.cellImage.backgroundColor = .gray
        self.cellImage.tintColor = .white
        self.cellImage.contentMode = .scaleAspectFill
        self.cellImage.image = UIImage(systemName: "photo.circle")
    }

    func fillCellData(model: Photo) {
        self.cellImage.convertToUIImageFromURL(model.path)
    }
}
