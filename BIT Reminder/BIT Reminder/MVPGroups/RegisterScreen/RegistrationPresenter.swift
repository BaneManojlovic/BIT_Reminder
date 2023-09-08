//
//  RegisterPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 8.9.23..
//

import UIKit

protocol RegistrationPresenterDelegate: AnyObject { }

class RegistrationPresenter {

    weak var delegate: RegistrationPresenterDelegate?

    // MARK: - Initialization

    init() { }

    // MARK: - Delegate Methods

    func attachView(view: RegistrationPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }
}
