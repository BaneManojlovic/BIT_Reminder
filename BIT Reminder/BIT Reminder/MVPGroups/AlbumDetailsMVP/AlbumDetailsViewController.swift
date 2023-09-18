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
        self.haveDeleteAndUploadButtons = true
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

    // MARK: - Overriden Action Methods

    override func deleteAction() {
        super.deleteAction()
        self.showCancelOrYesAlert(message: "Are you sure that you want to delete this Album?",
                                  yesHandler: {
            if let modelId = self.presenter?.albumId {
                self.presenter?.deleteAlbum(modelID: modelId)
            }
        })
    }

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

// MARK: - Conforming to AlbumDetailsPresenterDelegate

extension AlbumDetailsViewController: AlbumDetailsPresenterDelegate {

    func uploadPhotoSuccess() {
        // TODO: - Reload Recycle view
        DispatchQueue.main.async {
            debugPrint("Success ... reload Collection View ...")
            self.navigationController?.popViewController(animated: true)
        }
    }

    func uploadPhotoFailure(message: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: message)
        }
    }

    func deleteAlbumSuccess() {
        DispatchQueue.main.async {
            self.showOkAlert(message: "Album successfully deleted!", confirmation: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }

    func deleteAlbumFailure(message: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: message)
        }
    }

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
