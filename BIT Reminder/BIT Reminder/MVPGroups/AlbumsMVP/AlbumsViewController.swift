//
//  AlbumsViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import UIKit

class AlbumsViewController: BaseNavigationController {

    var presenter = AlbumsViewPresenter()
    lazy private var authFlowController = AuthentificationFlowController(currentViewController: self)

    private var albumsView: AlbumsView! {
        loadViewIfNeeded()
        return view as? AlbumsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.haveCreateFolderButton = true
        self.setupDelegates()
        self.setupTargets()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.getAlbums()
    }

    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Albums"
        self.albumsView.setupUI()
    }

    private func setupDelegates() {
        self.presenter.attachView(view: self)
        self.albumsView.tableView.delegate = self
        self.albumsView.tableView.dataSource = self
    }

    private func setupTargets() { }

    override func createFolderButtonAction() {
        super.createFolderButtonAction()

        if let user = self.presenter.user {
            /// Create the alert controller.
            let alert = UIAlertController(title: "Create new album", message: "Enter album title:", preferredStyle: .alert)
            /// Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = ""
            }
            /// Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
                if let textField = alert?.textFields?[0] as? UITextField {
                    if let text = textField.text {
                        let album = Album(albumName: text,
                                          profileId: user.profileId)
                        self.presenter.createNewAlbum(album: album)
                    }
                }
            }))
            /// Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension AlbumsViewController: AlbumsViewPresenterDelegate {

    func createNewAlbumFailure(message: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: message)
        }
    }

    func createNewAlbumSuccess() {
        self.showOkAlert(message: "New album created!", confirmation: {
                self.presenter.getAlbums()
            })
    }

    func getAlbumsFailure(message: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: message)
        }
    }

    func getAlbumsSuccess(response: [Album]) {
        DispatchQueue.main.async {
            self.albumsView.tableView.reloadData()
        }
    }
}

// MARK: - Conforming to UITableViewDelegate, UITableViewDataSource

extension AlbumsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.albums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumsTableViewCell.reuseIdentifier,
        for: indexPath) as? AlbumsTableViewCell else { return UITableViewCell() }
        let model = self.presenter.albums[indexPath.row]
        cell.setupCellData(model: model)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.presenter.albums[indexPath.row]
        if let modelId = model.id {
            self.authFlowController.goToAlbumDetails(albumId: modelId)
        }
    }
}
