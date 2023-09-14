//
//  AlbumsViewPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import Foundation

protocol AlbumsViewPresenterDelegate: AnyObject {
    
}

class AlbumsViewPresenter {
    
    weak var delegate: AlbumsViewPresenterDelegate?
    
    // MARK: - Initialization

    init() { }

    // MARK: - Delegate Methods

    func attachView(view: AlbumsViewPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }
}
