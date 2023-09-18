//
//  LargeImageViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 18.9.23..
//

import UIKit

class ImageDetailsViewController: UIViewController {

    var presenter: ImageDetailsPresenter?

    private var imageDetailsView: ImageDetailsView! {
        loadViewIfNeeded()
        return view as? ImageDetailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupDelegates()
        self.setupTargets()
    }

    private func setupUI() {
        self.imageDetailsView.setupUI()
        if let photo = self.presenter?.photo {
            self.imageDetailsView.setImage(model: photo)
        }
    }

    private func setupDelegates() {
        self.presenter?.attachView(view: self)
    }

    private func setupTargets() {
        self.imageDetailsView.closeImageButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        self.imageDetailsView.deleteImageButton.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
    }

    @objc func closeScreen() {
        self.dismiss(animated: true)
    }

    @objc func deleteImage() {
        self.showCancelOrYesAlert(message: "Are you sure that you want to delete image?",
                                  yesHandler: {
            self.presenter?.deletePhoto(modelId: self.presenter?.photo?.id ?? 0)
        })
    }
}

extension ImageDetailsViewController: ImageDetailsPresenterDelegate {

    func deleteImageSuccess() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name.reloadAlbumDetailsView, object: nil)
            self.showOkAlert(message: "Image deleted", confirmation: {
                self.dismiss(animated: true)
            })
        }
    }

    func deleteImageFailure(message: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: message, confirmation: {
//                self.dismiss(animated: true)
                self.view.window?.rootViewController?.dismiss(animated: true)
            })
        }
    }
}
