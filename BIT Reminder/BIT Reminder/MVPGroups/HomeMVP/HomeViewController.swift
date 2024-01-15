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
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.haveAddButton = true
        self.setupDelegates()
        self.setupTargets()
        self.configureSearch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.getReminders()
    }

    // MARK: - Private Setup Methods
    func configureSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.textColor = .white
        self.searchController.searchBar.searchTextField.attributedPlaceholder =  NSAttributedString.init(string: "Search...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        if let leftView = searchController.searchBar.searchTextField.leftView as? UIImageView {
               leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
            leftView.tintColor = UIColor.lightGray
           }
    }

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
        if isFiltering {
            return self.presenter.filteredReminders.count
        }
        return self.presenter.reminders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTableViewCell.reuseIdentifier,
        for: indexPath) as? ReminderTableViewCell else { return UITableViewCell() }
        /// create model to fill in data for cell
        var reminders = self.presenter.reminders[indexPath.row]
        /// determine what array to get for fill out data to cell
        if isFiltering {
            /// reminders filtered after search
            reminders = self.presenter.filteredReminders[indexPath.row]
        } else {
            /// reminders unfiltered
            reminders = self.presenter.reminders[indexPath.row]
        }
        /// fill in data for cell
        cell.fillCellWithData(model: reminders)
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
        
        if let index = tableView.indexPathForSelectedRow?.row {
            if isFiltering {
                /// filtered data
                if let filteredModelId = self.presenter.filteredReminders[index].id {
                    self.authFlowController.goToAddNewReminder(screenType: .reminderDetailsScreen, model: self.presenter.filteredReminders[indexPath.row])
                }
            } else {
               /// unfiltered data
                if let modelId = self.presenter.reminders[index].id {
                    self.authFlowController.goToAddNewReminder(screenType: .reminderDetailsScreen, model: self.presenter.reminders[indexPath.row])
                }
            }
        } else {
            debugPrint("No row selected")
        }
    }
    
    // Fill filteredReminders array with reminders filtered by title
    func filterContentForSearchText(_ searchText: String, name: Reminder? = nil) {
        self.presenter.filteredReminders = self.presenter.reminders.filter { (product: Reminder) -> Bool in
            return product.title.lowercased().contains(searchText.lowercased())
      }
        self.homeView.tableView.reloadData()
    }
}

// MARK: - Conforming to UISearchResultsUpdating

extension HomeViewController: UISearchResultsUpdating {
    
  func updateSearchResults(for searchController: UISearchController) {
      let searchBar = searchController.searchBar
      filterContentForSearchText(searchBar.text!)
  }
}

// MARK: - Conforming to UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {
    
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    filterContentForSearchText(searchBar.text!)
  }
}
