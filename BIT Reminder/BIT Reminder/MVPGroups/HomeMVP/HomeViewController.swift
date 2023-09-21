//
//  HomeViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 7.9.23..
//

import UIKit

class HomeViewController: BaseNavigationController {

    // MARK: - Properties

    var presenter = HomeViewPresenter()
    lazy private var authFlowController = AuthentificationFlowController(currentViewController: self)
    private var homeView: HomeView! {
        loadViewIfNeeded()
        return view as? HomeView
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.haveAddButton = true
        self.setupDelegates()
        self.setupTargets()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.getReminders()
    }

    // MARK: - Private Setup Methods

    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = L10n.titleLabelReminders
        self.homeView.setupUI()
    }

    private func setupDelegates() {
        self.presenter.attachView(view: self)
        self.homeView.tableView.delegate = self
        self.homeView.tableView.dataSource = self
    }

    private func setupTargets() { }

    // MARK: - Overriden Methods

    override func addButtonAction() {
        super.addButtonAction()
        self.authFlowController.goToAddNewReminder(screenType: .addNewReminderScreen, model: nil)
    }
}

// MARK: - Conforming to HomeViewPresenterDelegate

extension HomeViewController: HomeViewPresenterDelegate {

    func deleteReminderFailure(message: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: message)
        }
    }

    func deleteReminderSuccess() {
        DispatchQueue.main.async {
            self.homeView.tableView.reloadData()
        }
    }

    func getRemindersFailure(error: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: error)
        }
    }

    func getRemindersSuccess(response: [Reminder]) {
        DispatchQueue.main.async {
            if !response.isEmpty {
                self.homeView.homeMessageLabel.isHidden = true
                self.homeView.tableView.isHidden = false
                self.homeView.tableView.reloadData()
            } else {
                self.homeView.homeMessageLabel.isHidden = false
                self.homeView.tableView.isHidden = true
            }
        }
    }
}

// MARK: - Conforming to UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.reminders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTableViewCell.reuseIdentifier,
        for: indexPath) as? ReminderTableViewCell else { return UITableViewCell() }
        /// create model to fill in data for cell
        let model = self.presenter.reminders[indexPath.row]
        /// fill cell with model data
        cell.fillCellWithData(model: model)
        /// return cell
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let model = self.presenter.reminders[indexPath.row]
            self.presenter.deleteReminder(model: model)
            self.presenter.reminders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.presenter.reminders[indexPath.row]
        if let modelId = model.id {
            self.authFlowController.goToAddNewReminder(screenType: .reminderDetailsScreen, model: model)
        }
    }
}
