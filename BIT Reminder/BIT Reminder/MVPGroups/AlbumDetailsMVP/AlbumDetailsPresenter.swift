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
    func deleteAlbumSuccess()
    func deleteAlbumFailure(message: String)
}

class AlbumDetailsPresenter {

    // MARK: - Properties

    weak var delegate: AlbumDetailsPresenterDelegate?
    var authManager = AuthManager()
    var albumId: Int
    var album: Album?
    var photos: [Photo] = []

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

    func getAlbumByID(albumId: Int) -> Photo? {
        return self.photos.first(where: { $0.albumId == self.albumId})
    }

    // MARK: - API Methods

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

    func deleteAlbum(modelID: Int) {
        KRProgressHUD.show()
        Task {
            do {
                try await self.authManager.deleteAlbum(modelID: modelID) { error in
                    if let error = error {
                        debugPrint(error)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                           KRProgressHUD.dismiss()
                        }
                        self.delegate?.deleteAlbumFailure(message: error.localizedDescription)
                    } else {
                        debugPrint("")
                        KRProgressHUD.dismiss()
                        self.delegate?.deleteAlbumSuccess()
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
