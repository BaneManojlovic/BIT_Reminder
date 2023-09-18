//
//  AlbumDetailsView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 15.9.23..
//

import UIKit

class AlbumDetailsView: UIView {

    // MARK: - Outlets

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Setup Method

    func setupUI() {
        self.backgroundColor = Asset.backgroundBlueColor.color
        self.collectionView.register(UINib(nibName: AlbumPhotoCollectionViewCell.cellIdentifier, bundle: nil),
                                     forCellWithReuseIdentifier: AlbumPhotoCollectionViewCell.cellIdentifier)
        self.collectionView.backgroundColor = Asset.backgroundBlueColor.color
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.textLabel.textAlignment = .center
        self.textLabel.textColor = .white
        self.textLabel.text = "Album is empty"
    }
}
