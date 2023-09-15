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
        let model = Reminder(title: "Test dodavanja remindera 3",
                             description: "testing testing...",
                             important: true,
                             date: nil)
        self.presenter.addNewReminder(model: model)
    }
}

// MARK: - Conforming to AddNewReminderViewPresenterDelegate

extension AddNewReminderViewController: AddNewReminderViewPresenterDelegate {

    func addNewReminderFailure(message: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: message)
        }
    }

    func addNewReminderSuccess() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.showOkAlert(message: "New Reminder successfully added!", confirmation: {
                self.navigationController?.popViewController(animated: true)
            }, completion: nil)
        }
    }
}