//
//  ImageDetailsPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 18.9.23..
//

import Foundation
import KRProgressHUD

protocol ImageDetailsPresenterDelegate: AnyObject {
    func deleteImageSuccess()
    func deleteImageFailure(message: String)
}

class ImageDetailsPresenter {

    weak var delegate: ImageDetailsPresenterDelegate?
    var authManager = AuthManager()
    var photo: Photo?

    init(photo: Photo) {
        self.photo = photo
    }

    // MARK: - Delegate Methods

    func attachView(view: ImageDetailsPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }

    func deletePhoto(modelId: Int) {
        KRProgressHUD.show()
        Task {
            do {
                try await self.authManager.deletePhotoFromAlbum(modelID: modelId) { error in
                    if let error = error {
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                           KRProgressHUD.dismiss()
                        }
                        self.delegate?.deleteImageFailure(message: error.localizedDescription)
                    } else {
                        KRProgressHUD.dismiss()
                        self.delegate?.deleteImageSuccess()
                    }
                }
            }
        }
    }
}
