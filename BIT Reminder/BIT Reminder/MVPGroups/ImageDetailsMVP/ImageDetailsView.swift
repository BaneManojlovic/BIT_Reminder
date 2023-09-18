//
//  ImageDetailsView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 18.9.23..
//

import UIKit

class ImageDetailsView: UIView {

    // MARK: - Outlets

    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var closeImageButton: UIButton!
    @IBOutlet weak var deleteImageButton: UIButton!

    func setupUI() {
        self.backgroundColor = .black
        self.largeImageView.contentMode = .scaleAspectFill
        self.largeImageView.backgroundColor = .gray
        self.largeImageView.image = UIImage(systemName: "photo.circle")
        self.largeImageView.tintColor = .white
        self.closeImageButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        self.closeImageButton.tintColor = .white
        self.deleteImageButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        self.deleteImageButton.tintColor = .white
    }

    func setImage(model: Photo) {
        self.largeImageView.convertToUIImageFromURL(model.path)
    }
}
