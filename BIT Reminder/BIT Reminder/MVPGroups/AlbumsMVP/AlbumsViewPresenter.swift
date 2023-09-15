//
//  AlbumsViewPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import Foundation
import KRProgressHUD

protocol AlbumsViewPresenterDelegate: AnyObject {
    
}

class AlbumsViewPresenter {
    
    weak var delegate: AlbumsViewPresenterDelegate?
    var albums: [Album] = []
    
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
    }
}
