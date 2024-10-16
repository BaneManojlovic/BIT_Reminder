//
//  AlbumsViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import UIKit

class AlbumsViewController: BaseNavigationController {

    // MARK: - Properties

    var presenter = AlbumsViewPresenter()
    lazy private var authFlowController = AuthentificationFlowController(currentViewController: self)
    private var albumsView: AlbumsView! {
        loadViewIfNeeded()
        return view as? AlbumsView
    }

    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.haveCreateFolderButton = true
        self.setupDelegates()
        self.setupTargets()
        self.configureSearch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.getAlbums()
    }

    // MARK: - Setup Methods

    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = L10n.titleLabelAlbums
        self.albumsView.setupUI()
    }

    private func setupDelegates() {
        self.presenter.attachView(view: self)
        self.albumsView.tableView.delegate = self
        self.albumsView.tableView.dataSource = self
    }

    private func setupTargets() { }

    func configureSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.textColor = .white
        self.searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString.init(string: L10n.labelPlaceholderSearch, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        if let leftView = searchController.searchBar.searchTextField.leftView as? UIImageView {
               leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
            leftView.tintColor = UIColor.lightGray
           }
    }

    override func createFolderButtonAction() {
        super.createFolderButtonAction()

        if let user = self.presenter.user {
            /// Create the alert controller.
            let alert = UIAlertController(title: L10n.labelMessageCreateNewAlbum,
                                          message: L10n.labelMessageEnterAlbumTitle,
                                          preferredStyle: .alert)
            /// Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = ""
            }
            /// Cancel action for create new Album feature
            alert.addAction(UIAlertAction(title: L10n.alertButtonTitleCancel,
                                          style: .cancel,
                                          handler: { _ in
                self.dismiss(animated: true)
            }))
            /// Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: L10n.labelTitleCreate, style: .default, handler: { [weak alert] (_) in
                if let textField = alert?.textFields?[0] as? UITextField {
                    if let text = textField.text, text != "" {
                        let album = Album(albumName: text,
                                          profileId: user.profileId)
                        self.presenter.createNewAlbum(album: album)
                    } else {
                        self.presenter.delegate?.createNewAlbumFailure(message: L10n.labelMessageTitleMandatory)
                    }
                }
            }))
            /// Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Conforming to AlbumsViewPresenterDelegate

extension AlbumsViewController: AlbumsViewPresenterDelegate {

    func deleteAlbumSuccess() {
        DispatchQueue.main.async {
            self.albumsView.tableView.reloadData()
        }
    }

    func deleteAlbumFailure(message: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: message)
        }
    }

    func createNewAlbumFailure(message: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: message)
        }
    }

    func createNewAlbumSuccess() {
        self.presenter.getAlbums()
    }

    func getAlbumsFailure(message: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: message)
        }
    }

    func getAlbumsSuccess(response: [Album]) {
        DispatchQueue.main.async {
            if !response.isEmpty {
                self.albumsView.messageLabel.isHidden = true
                self.albumsView.tableView.isHidden = false
                self.albumsView.tableView.reloadData()
            } else {
                self.albumsView.messageLabel.isHidden = false
                self.albumsView.tableView.isHidden = true
            }
        }
    }
}

// MARK: - Conforming to UITableViewDelegate, UITableViewDataSource

extension AlbumsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return self.presenter.filteredAlbums.count
        }
        return self.presenter.albums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumsTableViewCell.reuseIdentifier,
        for: indexPath) as? AlbumsTableViewCell else { return UITableViewCell() }
        /// create model to fill in data for cell
        var model = self.presenter.albums[indexPath.row]
        /// determine what array to get for fill out data to cell
        if isFiltering {
            /// albums filtered after search
            model = self.presenter.filteredAlbums[indexPath.row]
        } else {
            /// albums unfiltered
            model = self.presenter.albums[indexPath.row]
        }
        /// fill in data for cell
        cell.setupCellData(model: model)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let model = self.presenter.albums[indexPath.row]
            self.presenter.deleteAlbum(model: model)
            self.presenter.albums.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = tableView.indexPathForSelectedRow?.row {
            if isFiltering {
                /// filtered data
                if let filteredModelId = self.presenter.filteredAlbums[index].id {
                    self.authFlowController.goToAlbumDetails(albumId: filteredModelId,
                                                             albumName: self.presenter.filteredAlbums[index].albumName)
                }
            } else {
                /// unfiltered data
                if let modelId = self.presenter.albums[index].id {
                    self.authFlowController.goToAlbumDetails(albumId: modelId, albumName: self.presenter.albums[index].albumName)
                }
            }
        } else {
            debugPrint("No row selected")
        }
    }

    // Fill filteredAlbums array with albums filtered by albumName
    func filterContentForSearchText(_ searchText: String,
                                    name: Album? = nil) {
        self.presenter.filteredAlbums = self.presenter.albums.filter { (product: Album) -> Bool in
            return product.albumName.lowercased().contains(searchText.lowercased())
      }
        self.albumsView.tableView.reloadData()
    }
}

// MARK: - Conforming to UISearchResultsUpdating

extension AlbumsViewController: UISearchResultsUpdating {

  func updateSearchResults(for searchController: UISearchController) {
      let searchBar = searchController.searchBar
      filterContentForSearchText(searchBar.text!)
  }
}

// MARK: - Conforming to UISearchBarDelegate

extension AlbumsViewController: UISearchBarDelegate {

  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    filterContentForSearchText(searchBar.text!)
  }
}
