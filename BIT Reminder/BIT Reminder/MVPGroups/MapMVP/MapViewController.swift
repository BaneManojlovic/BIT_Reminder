//
//  MapViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import UIKit

class MapViewController: BaseNavigationController {

 
    var presenter = MapViewPresenter()
   
    private var mapView: MapView! {
        loadViewIfNeeded()
        return view as? MapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupDelegates()
        self.setupTargets()
        
    }

    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "Map"
        self.mapView.setupUI()
    }
    
    private func setupDelegates() {
        self.presenter.attachView(view: self)
    }

    private func setupTargets() {
        
    }
}

extension MapViewController: MapViewPresenterDelegate {
    
}
