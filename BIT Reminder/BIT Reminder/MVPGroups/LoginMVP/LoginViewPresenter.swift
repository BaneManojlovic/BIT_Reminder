//
//  LoginPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 8.9.23..
//

import UIKit

protocol LoginViewPresenterDelegate: AnyObject {
    
}

class LoginViewPresenter {
    
    weak var delegate: LoginViewPresenterDelegate?

    // MARK: - Initialization

    init() { }

    // MARK: - Delegate Methods

    func attachView(view: LoginViewPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }
    
}
