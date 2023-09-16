//
//  AddNewAlbumViewPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 15.9.23..
//

import Foundation
import KRProgressHUD

protocol AddNewAlbumViewPresenterDelegate: AnyObject {
    
}

class AddNewAlbumViewPresenter {
    
    weak var delegate: AddNewAlbumViewPresenterDelegate?
    var authManager = AuthManager()

    // MARK: - Initialization

    init() { }

    // MARK: - Delegate Methods

    func attachView(view: AddNewAlbumViewPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }

    func uploadPhoto(image: Data) {
        // TODO: - Call API
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
