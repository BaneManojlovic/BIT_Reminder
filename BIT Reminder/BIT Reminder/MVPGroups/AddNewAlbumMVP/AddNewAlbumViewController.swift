//
//  AddNewAlbumViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 15.9.23..
//

import UIKit

class AddNewAlbumViewController: BaseNavigationController, UINavigationControllerDelegate {

    // MARK: - Properties

    var presenter = AddNewAlbumViewPresenter()
    let imagePickerController = UIImagePickerController()

    private var addNewAlbumView: AddNewAlbumView! {
        loadViewIfNeeded()
        return view as? AddNewAlbumView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.haveBackButton = true
        self.setupDelegates()
        self.setupTargets()
    }

    private func setupUI() {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Add New Album"
        self.addNewAlbumView.setupUI()
    }

    private func setupDelegates() {
        self.presenter.attachView(view: self)
        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = true
    }

    private func setupTargets() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(openGallery))
        self.addNewAlbumView.uploadImage.addGestureRecognizer(tap)
    }

    @objc func openGallery() {
        debugPrint("Tep tep ...")
        let actionSheet = UIAlertController(title: "", message: "Upload new photo:", preferredStyle: .actionSheet)
        /// add take photo via camer action
        actionSheet.addAction(UIAlertAction(title: "Take photo via camera",
                                            style: .default,
                                            handler: { [self] (_: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }))
        /// add chose photo from gallery action
        actionSheet.addAction(UIAlertAction(title: "Choose photo from library",
                                            style: .default,
                                            handler: { [self] (_: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        /// add cancel action
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        /// present action sheet
        self.present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - Conforming to AddNewAlbumViewPresenterDelegate

extension AddNewAlbumViewController: AddNewAlbumViewPresenterDelegate { }

// MARK: - Conforming to UIImagePickerControllerDelegate

extension AddNewAlbumViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        var image: UIImage?

        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = img
        } else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = img
        }

        if let image = image?.jpegData(compressionQuality: 0.8) {
            debugPrint("Image = \(image)")
            self.presenter.uploadPhoto(image: image)
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
