//
//  AlbumsViewPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import Foundation
import KRProgressHUD

protocol AlbumsViewPresenterDelegate: AnyObject {
    func getAlbumsFailure(error: String)
    func getAlbumsSuccess(response: [Album])
}

class AlbumsViewPresenter {

    weak var delegate: AlbumsViewPresenterDelegate?
    var albums: [Album] = []
    var authManager = AuthManager()
    // MARK: - Initialization

    init() { }

    // MARK: - Delegate Methods

    func attachView(view: AlbumsViewPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }

    func getAlbums() {
//        KRProgressHUD.show()
//        self.albums.append(Album(title: "Barselona", count: 99))
//        self.albums.append(Album(title: "Hungaro ring", count: 73))
//        self.albums.append(Album(title: "Work", count: 41))
//        self.albums.append(Album(title: "Birthday", count: 23))
//        self.albums.append(Album(title: "Casual walk", count: 12))
//        KRProgressHUD.dismiss()
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
                        self.delegate?.getAlbumsFailure(error: error.localizedDescription)
                    } else {
                        debugPrint("")
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
}

/*
 func getReminders() {
     self.reminders = []
     KRProgressHUD.show()
     Task {
         do {
             try await self.authManager.getReminders { error, response  in
                 if let error = error {
                     debugPrint(error)
                     DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        KRProgressHUD.dismiss()
                     }
                     self.delegate?.getRemindersFailure(error: error.localizedDescription)
                 } else {
                     debugPrint("")
                     KRProgressHUD.dismiss()
                     if let resp = response {
                         debugPrint(resp)
                         self.reminders = resp
                         self.delegate?.getRemindersSuccess(response: resp)
                     }
                 }
             }
         }
     }
 }

 */
