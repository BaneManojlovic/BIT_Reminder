//
//  AlbumDetailsPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 15.9.23..
//

import Foundation
import KRProgressHUD

protocol AlbumDetailsPresenterDelegate: AnyObject {
    func getPhotosSuccess(photos: [Photo])
    func getPhotosFailure(message: String)
}

class AlbumDetailsPresenter {

    // MARK: - Properties

    weak var delegate: AlbumDetailsPresenterDelegate?
    var authManager = AuthManager()
    var albumId: Int

    // MARK: - Initialization

    init(albumId: Int) {
        self.albumId = albumId
    }

    // MARK: - Delegate Methods

    func attachView(view: AlbumDetailsPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }

    // MARK: - Request API Methods

    func getAlbumDetails(albumId: Int) {
        KRProgressHUD.show()
        Task {
            do {
                try await self.authManager.getPhotos(albumId: albumId) { error, response in
                    if let error = error {
                        debugPrint(error)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                           KRProgressHUD.dismiss()
                        }
                        self.delegate?.getPhotosFailure(message: error.localizedDescription)
                    } else {
                        debugPrint("")
                        KRProgressHUD.dismiss()
                        if let resp = response {
                            debugPrint(resp)
                            self.delegate?.getPhotosSuccess(photos: resp)
                        }
                    }
                }
            }
        }
    }

    func uploadPhoto(image: Data) {
        // TODO: - Call API / Check how does this work
        KRProgressHUD.show()
        Task {
            do {
                try await self.authManager.uploadPhoto(imageData: image) { error, response in
                    if let error = error {
                        debugPrint(error)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                           KRProgressHUD.dismiss()
                        }
                    } else {
                        if let url = response {
                            debugPrint("\(url)")
                        }
                        debugPrint("ok")
                        KRProgressHUD.dismiss()
                    }
                }
            }
        }
    }
}
