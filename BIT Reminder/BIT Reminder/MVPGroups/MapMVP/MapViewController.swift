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
    lazy private var authFlowController = AuthentificationFlowController(currentViewController: self)
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
        self.setupObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let location = myLocation {
            self.setupUserCurrentLocation(location)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removePins()
    }

    // MARK: - Setup Methods

    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.setupLocationManager()
        self.mapView.setupUI()
        self.checkIsLocationManageEnabled()
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showPins(_:)),
                                               name: Notification.Name.showMapPins,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func checkIsLocationManageEnabled() {
        let locationServicesEnabled = CLLocationManager.locationServicesEnabled()
        if locationServicesEnabled {
            debugPrint("Servis enabled")
        } else {
            debugPrint("Servis disabled")
            locationManager.requestWhenInUseAuthorization()
        }
    }

    @objc func showPins(_ notification: NSNotification) {
        if let notif = notification.userInfo?["location"] as? String {
            self.showChoosenDestinations(query: notif)
        }
    }

    private func setupDelegates() {
        self.presenter.attachView(view: self)
        self.mapView.mapView.delegate = self
        self.locationManager.delegate = self
    }

    private func setupTargets() {
        self.mapView.clearMapButton.addTarget(self, action: #selector(removePinAndSetUserLocation), for: .touchUpInside)
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
        self.removePins()
        self.authFlowController.goToLocationList()
    }

    func removePins() {
        let annotations = self.mapView.mapView.annotations
        for item in annotations {
            if let annotation = item as? MKAnnotation {
                self.mapView.mapView.removeAnnotation(annotation)
            }
        }
        /*
         Or try this:
         func removeAllAnnotations() {
             for annotation in self.mapView.annotations {
                 self.mapView.removeAnnotation(annotation)
             }
         }
         */
    }

    @objc func removePinAndSetUserLocation() {
        self.removePins()
        if let location = myLocation {
            self.setupUserCurrentLocation(location)
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
        pin.title = L10n.labelMessageMyLocation
        self.mapView.mapView.showsUserLocation = true
        self.mapView.mapView.addAnnotation(pin)
    }

    func showChoosenDestinations(query: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.region = self.mapView.mapView.region
        searchRequest.naturalLanguageQuery = query
        searchRequest.resultTypes = [.pointOfInterest, .address]

        var search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else {
                debugPrint("Error: \(error?.localizedDescription ?? "Unknown error")")
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
            handleNotDeterminedAuthorization()
        case .restricted:
            handleRestrictedAuthorization()
        case .denied:
            promptForAuthorization()
        case .authorizedAlways:
            self.startLocationUpadate()
        case .authorizedWhenInUse:
            self.startLocationUpadate()
        case .authorized:
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
