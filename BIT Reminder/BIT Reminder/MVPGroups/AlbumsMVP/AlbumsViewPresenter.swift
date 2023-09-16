//
//  AlbumsViewPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import Foundation
import KRProgressHUD

protocol AlbumsViewPresenterDelegate: AnyObject {
    func getAlbumsFailure(message: String)
    func getAlbumsSuccess(response: [Album])
    func createNewAlbumFailure(message: String)
    func createNewAlbumSuccess()
}

class AlbumsViewPresenter {

    weak var delegate: AlbumsViewPresenterDelegate?
    var albums: [Album] = []
    var authManager = AuthManager()
    var userDefaultHelper = UserDefaultsHelper()
    var user: UserModel?

    // MARK: - Initialization

    init() {
        self.user = self.userDefaultHelper.getUser()
    }

    // MARK: - Delegate Methods

    func attachView(view: AlbumsViewPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }

    func getAlbums() {
        self.albums = []
        KRProgressHUD.show()
        Task {
            do {
                try await self.authManager.getAlbums { error, response in
                    if let error = error {
                        debugPrint(error)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                           KRProgressHUD.dismiss()
                        }
                        self.delegate?.getAlbumsFailure(message: error.localizedDescription)
                    } else {
                        KRProgressHUD.dismiss()
                        if let resp = response {
                            debugPrint(resp)
                            self.albums = resp
                            self.delegate?.getAlbumsSuccess(response: resp)
                        }
                    }
                }
            }
        }
    }

    func createNewAlbum(album: Album) {
        KRProgressHUD.show()
        Task {
            do {
                try await self.authManager.createNewAlbum(album: album) { error in
                    if let error = error {
                        debugPrint(error.localizedDescription)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                           KRProgressHUD.dismiss()
                        }
                        self.delegate?.createNewAlbumFailure(message: error.localizedDescription)
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                            KRProgressHUD.dismiss()
                            self.delegate?.createNewAlbumSuccess()
                        }
                    }
                }
            }
        }
    }
}
