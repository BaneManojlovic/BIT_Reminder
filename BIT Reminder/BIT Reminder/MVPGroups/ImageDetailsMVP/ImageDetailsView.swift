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

    // MAKR: - Setup Methods

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
        /// identifiers for UI tests; image views are hidden from accessibility by default
        self.largeImageView.isAccessibilityElement = true
        self.largeImageView.accessibilityIdentifier = "albums_full_image_viewer"
        self.closeImageButton.accessibilityIdentifier = "albums_btn_back"
    }

    func setImage(model: Photo) {
        self.largeImageView.convertToUIImageFromURL(model.path)
    }
}
