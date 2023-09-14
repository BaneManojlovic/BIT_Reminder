//
//  AddNewReminderViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import UIKit

class AddNewReminderViewController: BaseNavigationController {

    var presenter = AddNewReminderViewPresenter()

    private var addNewReminderView: AddNewReminderView! {
        loadViewIfNeeded()
        return view as? AddNewReminderView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.haveBackButton = true
        self.setupDelegates()
        self.setupTargets()
    }

    private func setupUI() {
        self.addNewReminderView.setupUI()
        self.title = "Add New Reminder"
    }

    private func setupDelegates() {
        self.presenter.attachView(view: self)
    }

    private func setupTargets() {
        self.addNewReminderView.addButton.addTarget(self, action: #selector(addNewTapped), for: .touchUpInside)
    }

    @objc func addNewTapped() {
        self.presenter.addNewReminder()
    }
}

// MARK: - Conforming to AddNewReminderViewPresenterDelegate

extension AddNewReminderViewController: AddNewReminderViewPresenterDelegate { }
