//
//  AlbumDetailsViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 15.9.23..
//

import UIKit

class AlbumDetailsViewController: BaseNavigationController, UINavigationControllerDelegate {

    var presenter: AlbumDetailsPresenter?
    let imagePickerController = UIImagePickerController()

    private var albumDetailsView: AlbumDetailsView! {
        loadViewIfNeeded()
        return view as? AlbumDetailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.haveBackButton = true
        self.haveUploadButton = true
        self.setupDelegates()
        self.setupTargets()
        self.presenter?.getAlbumDetails(albumId: self.presenter?.albumId ?? 0)
    }

    private func setupUI() {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Album Details"
        self.albumDetailsView.setupUI()
    }

    private func setupDelegates() {
        self.presenter?.attachView(view: self)
        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = true
    }

    private func setupTargets() { }

    override func uploadButtonAction() {
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

extension AlbumDetailsViewController: AlbumDetailsPresenterDelegate {

    func getPhotosSuccess(photos: [Photo]) {
        DispatchQueue.main.async {
            self.albumDetailsView.textLabel.text = "\(photos)"
        }
    }

    func getPhotosFailure(message: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: message)
        }
    }
}

// MARK: - Conforming to UIImagePickerControllerDelegate

extension AlbumDetailsViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        var image: UIImage?

        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = img
        } else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = img
        }

        if let image = image?.jpegData(compressionQuality: 0.8) {
            debugPrint("Image = \(image)")
            self.presenter?.uploadPhoto(image: image)
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
