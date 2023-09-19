//
//  FavoriteLocationsViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 19.9.23..
//

import UIKit

class FavoriteLocationsViewController: UIViewController {

    var presenter = FavoriteLocationsPresenter()

    private var favoriteLocationsView: FavoriteLocationsView! {
        loadViewIfNeeded()
        return view as? FavoriteLocationsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupDelegates()
        self.setupTargets()
        self.presenter.getLocationList()
    }

    private func setupUI() {
        self.favoriteLocationsView.setupUI()
    }

    private func setupDelegates() {
        self.presenter.attachView(view: self)
        self.favoriteLocationsView.tableView.delegate = self
        self.favoriteLocationsView.tableView.dataSource = self
    }

    private func setupTargets() {
        self.favoriteLocationsView.closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
    }

    @objc func closeScreen() {
        self.dismiss(animated: true)
    }

}

// MARK: - Conforming to FavoriteLocationsPresenterDelegate

extension FavoriteLocationsViewController: FavoriteLocationsPresenterDelegate {

    func chooseLocation(item: String) { }
}

// MARK: - Conforming to UITableViewDelegate, UITableViewDataSource

extension FavoriteLocationsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.locationList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteLocationsTableViewCell.reuseIdentifier,
        for: indexPath) as? FavoriteLocationsTableViewCell else { return UITableViewCell() }
        let model = self.presenter.locationList[indexPath.row]
        cell.setupCellData(model: model)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.presenter.locationList[indexPath.row]
        debugPrint(model)
        let userInfo = ["location": model]
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name.showMapPins, object: nil, userInfo: userInfo)
            self.showOkAlert(message: "Odabrali ste \(model)", confirmation: {
                self.dismiss(animated: true)
            })
        }
    }
}
