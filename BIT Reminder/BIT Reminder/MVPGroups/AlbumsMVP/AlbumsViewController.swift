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
            /// Cancel action for create new Album feature
            alert.addAction(UIAlertAction(title: "Cancel",
                                          style: .cancel,
                                          handler: { _ in
                self.dismiss(animated: true)
            }))
            /// Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
                if let textField = alert?.textFields?[0] as? UITextField {
                    if let text = textField.text, text != "" {
                        let album = Album(albumName: text,
                                          profileId: user.profileId)
                        self.presenter.createNewAlbum(album: album)
                    } else {
                        self.presenter.delegate?.createNewAlbumFailure(message: "Title is mandatory!")
                    }
                }
            }))
            /// Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
    }
}

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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let model = self.presenter.albums[indexPath.row]
            self.presenter.deleteAlbum(model: model)
            self.presenter.albums.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.presenter.albums[indexPath.row]
        if let modelId = model.id {
            self.authFlowController.goToAlbumDetails(albumId: modelId)
        }
    }
}
