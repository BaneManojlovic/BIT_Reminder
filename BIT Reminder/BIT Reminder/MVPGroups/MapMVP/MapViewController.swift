//
//  MapViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - Properties

    var presenter = MapViewPresenter()
    let locationManager = CLLocationManager()
    var myLocation: CLLocation?

    private var mapView: MapView! {
        loadViewIfNeeded()
        return view as? MapView
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupDelegates()
        self.setupTargets()
    }

    // MARK: - Setup Methods

    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.setupLocationManager()
        self.mapView.setupUI()
        self.checkIsLocationManageEnabled()
    }

    func checkIsLocationManageEnabled() {
        let locationServicesEnabled = CLLocationManager.locationServicesEnabled()
        if locationServicesEnabled {
            debugPrint("Servis je Enabled")
        } else {
            debugPrint("Servis je disabled")
            locationManager.requestWhenInUseAuthorization()
        }
    }

    private func setupDelegates() {
        self.presenter.attachView(view: self)
        self.mapView.mapView.delegate = self
        self.locationManager.delegate = self
    }

    private func setupTargets() {
        self.mapView.myLocationButton.addTarget(self, action: #selector(myLocationButtonAction), for: .touchUpInside)
        self.mapView.openLocationListButton.addTarget(self, action: #selector(openLocationListButtonAction), for: .touchUpInside)
    }

    // MARK: - Action Methods

    @objc func myLocationButtonAction() {
        if let location = myLocation {
            self.setupUserCurrentLocation(location)
        }
    }

    @objc func openLocationListButtonAction() {
        debugPrint("location list...")
        let searchRequest = MKLocalSearch.Request()
//        searchRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: [.bank, .gasStation]) // or you can use excluding
        searchRequest.region = self.mapView.mapView.region
        searchRequest.naturalLanguageQuery = "banka"
        searchRequest.resultTypes = [.pointOfInterest, .address]

        var search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else {
                debugPrint("Error: \(error?.localizedDescription ?? "No error specified").")
                return
            }
            // Create annotation for every map item
            for mapItem in response.mapItems {
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                annotation.subtitle = mapItem.phoneNumber
                self.mapView.mapView.addAnnotation(annotation)
            }
            self.mapView.mapView.setRegion(response.boundingRegion, animated: true)
        }
    }

    private func setupUserCurrentLocation(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05,
                                    longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate,
                                        span: span)
        mapView.mapView.setRegion(region, animated: true)
        self.addPin(coordinate)
    }

    private func addPin(_ coordinate: CLLocationCoordinate2D) {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "My current location"
        self.mapView.mapView.showsUserLocation = true
        self.mapView.mapView.addAnnotation(pin)
    }
}

// MARK: - Conforming to MapViewPresenterDelegate

extension MapViewController: MapViewPresenterDelegate { }

// MARK: - Conforming to MKMapViewDelegate

extension MapViewController: MKMapViewDelegate { }

// MARK: - Conforming to CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            self.myLocation = location
            self.setupUserCurrentLocation(location)
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus

        switch status {
        case .notDetermined:
            debugPrint("Status je notDetermined")
            handleNotDeterminedAuthorization()
        case .restricted:
            debugPrint("Status je restricted")
            handleRestrictedAuthorization()
        case .denied:
            debugPrint("Status je denied")
            promptForAuthorization()
        case .authorizedAlways:
            debugPrint("Status je authorizedAlways")
            self.startLocationUpadate()
        case .authorizedWhenInUse:
            debugPrint("Status je authorizedWhenInUse")
            self.startLocationUpadate()
        case .authorized:
            debugPrint("Status je authorized")
            self.startLocationUpadate()
        @unknown default:
            debugPrint("default...")
        }
    }

    func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        startLocationUpadate()
    }

    func startLocationUpadate() {
        locationManager.startUpdatingLocation()
    }

    func promptForAuthorization() { }

    func handleRestrictedAuthorization() { }

    func handleNotDeterminedAuthorization() { }
}
