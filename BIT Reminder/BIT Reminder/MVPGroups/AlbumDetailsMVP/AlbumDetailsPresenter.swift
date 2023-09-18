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
    func uploadPhotoSuccess()
    func uploadPhotoFailure(message: String)
}

class AlbumDetailsPresenter {

    // MARK: - Properties

    weak var delegate: AlbumDetailsPresenterDelegate?
    var authManager = AuthManager()
    var albumId: Int
    var albumName: String
    var album: Album?
    var photos: [Photo] = []

    // MARK: - Initialization

    init(albumId: Int, albumName: String) {
        self.albumId = albumId
        self.albumName = albumName
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
        self.photos = []
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
                            self.photos = resp
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
        KRProgressHUD.show()
        Task {
            do {
                try await self.authManager.uploadPhoto(imageData: image) { error, response in
                    if let error = error {
                        debugPrint(error)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                           KRProgressHUD.dismiss()
                        }
                        self.delegate?.uploadPhotoFailure(message: error.localizedDescription)
                    } else {
                        if let url = response {
                            debugPrint("\(url)")
                            self.savePhotoToDataBase(path: "\(url)", albumId: self.albumId)
                        }
                        debugPrint("ok")
                    }
                }
            }
        }
    }

    func savePhotoToDataBase(path: String, albumId: Int) {
        Task {
            do {
                try await self.authManager.savePhotoToDatabase(model: Photo(path: path, albumId: albumId)) { error in
                    if let error = error {
                        debugPrint(error)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                           KRProgressHUD.dismiss()
                        }
                        self.delegate?.uploadPhotoFailure(message: error.localizedDescription)
                    } else {
                        KRProgressHUD.dismiss()
                        self.delegate?.uploadPhotoSuccess()
                    }
                }
            }
        }
    }
}
