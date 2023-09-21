//
//  MapViewPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import Foundation

protocol MapViewPresenterDelegate: AnyObject { }

class MapViewPresenter {

    // MARK: - Properties

    weak var delegate: MapViewPresenterDelegate?

    // MARK: - Initialization

    init() { }

    // MARK: - Delegate Methods

    func attachView(view: MapViewPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }
}
