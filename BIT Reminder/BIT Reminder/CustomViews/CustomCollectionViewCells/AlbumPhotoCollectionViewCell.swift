//
//  AlbumPhotoCollectionViewCell.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 18.9.23..
//

import UIKit

class AlbumPhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellImage: UIImageView!

    static let cellIdentifier = "AlbumPhotoCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupUI()
    }

    func setupUI() {
        self.cellImage.backgroundColor = .gray
        self.cellImage.tintColor = .white
        self.cellImage.contentMode = .scaleAspectFill
        self.cellImage.image = UIImage(systemName: "photo.circle")
    }

    func fillCellData(model: Photo) {
        debugPrint("Image path: \(model.path)")
        self.cellImage.convertToUIImageFromURL(model.path)
    }
}
