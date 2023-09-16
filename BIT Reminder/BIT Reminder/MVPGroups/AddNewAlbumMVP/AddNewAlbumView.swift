//
//  AddNewAlbumView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 15.9.23..
//

import UIKit

class AddNewAlbumView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!

    func setupUI() {
        self.backgroundColor = Asset.backgroundBlueColor.color
        /// setup for titleLabel
        self.titleLabel.text = "Set Album title:"
        self.titleLabel.textColor = .white
        self.titleLabel.textAlignment = .left
        self.titleLabel.font = UIFont.systemFont(ofSize: 20)
        /// titleTextField TextField
        self.titleTextField.textColor = .white
        self.titleTextField.font = UIFont.systemFont(ofSize: 20)
        self.titleTextField.backgroundColor = Asset.textfieldBlueColor.color
        self.titleTextField.layer.cornerRadius = 10
        self.titleTextField.attributedPlaceholder = NSAttributedString(
                                                       string: "title",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        /// setup for upload image
        self.uploadImage.image = UIImage(systemName: "square.and.arrow.up")
        self.uploadImage.isUserInteractionEnabled = true
        /// setup for saveButton button
        self.saveButton.backgroundColor = Asset.buttonBlueColor.color
        self.saveButton.setTitle("Save", for: .normal)
        self.saveButton.tintColor = .white
        self.saveButton.layer.cornerRadius = 10
    }

}
