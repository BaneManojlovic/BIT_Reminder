//
//  HomeViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 7.9.23..
//

import UIKit

class HomeViewController: BaseViewController {

    // MARK: - Properties

    var presenter = HomeViewPresenter()

    // MARK: - Private Properties

    private var homeView: HomeView! {
        loadViewIfNeeded()
        return view as? HomeView
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupDelegates()
    }

    // MARK: - Private Setup Methods

    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.homeView.setupUI()
    }

    private func setupDelegates() {
        self.presenter.attachView(view: self)
    }
}

// MARK: - Conforming to HomeViewPresenterDelegate

extension HomeViewController: HomeViewPresenterDelegate { }
