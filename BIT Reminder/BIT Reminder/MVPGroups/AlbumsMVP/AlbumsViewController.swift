//
//  AlbumsViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import UIKit

class AlbumsViewController: BaseNavigationController {

    var presenter = AlbumsViewPresenter()

    private var albumsView: AlbumsView! {
        loadViewIfNeeded()
        return view as? AlbumsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.haveAddButton = true
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
}

extension AlbumsViewController: AlbumsViewPresenterDelegate {

    func getAlbumsFailure(error: String) {
        DispatchQueue.main.async {
            self.showOkAlert(message: error)
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
}
