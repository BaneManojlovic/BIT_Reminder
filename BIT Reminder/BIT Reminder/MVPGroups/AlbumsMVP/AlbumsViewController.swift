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
    }

    private func setupTargets() {
        
    }
}

extension AlbumsViewController: AlbumsViewPresenterDelegate {
    
}
