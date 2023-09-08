//
//  HomeViewPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 7.9.23..
//

import Foundation

protocol HomeViewPresenterDelegate: AnyObject { }

class HomeViewPresenter {

    weak var delegate: HomeViewPresenterDelegate?

    // MARK: - Initialization

    init() { }

    // MARK: - Delegate Methods

    func attachView(view: HomeViewPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }
}
