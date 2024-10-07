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
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserLocationIfAvailable()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removePins()
    }

    // MARK: - Setup Methods

    private func setup() {
        navigationController?.isNavigationBarHidden = true
        setupLocationManager()
        setupObservers()
        setupDelegates()
        setupTargets()
        mapView.setupUI()
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
        updateUserLocationIfAvailable()
    }

    @objc func openLocationListButtonAction() {
        removePins()
        authFlowController.goToLocationList()
    }

    @objc func removePinAndSetUserLocation() {
        self.removePins()
        if let location = myLocation {
            self.setupUserCurrentLocation(location)
            self.mapView.clearMapButton.isHidden = true
        }
    }

    // MARK: - Location Hanling

    private func updateUserLocationIfAvailable() {
        guard let location = myLocation else {
            setupLocationManager()
            return
        }
        setupUserCurrentLocation(location)
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

    func removePins() {
        let annotations = self.mapView.mapView.annotations
        for item in annotations {
            if let annotation = item as? MKAnnotation {
                self.mapView.mapView.removeAnnotation(annotation)
            }
        }
    }

    func showChoosenDestinations(query: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.region = self.mapView.mapView.region
        searchRequest.naturalLanguageQuery = query
        searchRequest.resultTypes = [.pointOfInterest, .address]
        self.mapView.clearMapButton.isHidden = false

        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else {
                debugPrint("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
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

    func extractPhoneNumber(from subtitle: String) -> String? {
        let components = subtitle.components(separatedBy: " ")
        return components.joined()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotationView"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true

            // Extract phone number from the subtitle and pass it to the callout view
            if let subtitle = annotation.subtitle {
                let phoneNumber = extractPhoneNumber(from: subtitle ?? "")
                let customCalloutView = CustomCalloutView(frame: CGRect(x: 0, y: 0, width: 200, height: 70))
                customCalloutView.configure(withTitle: "", subtitle: subtitle, phoneNumber: phoneNumber)
                annotationView?.detailCalloutAccessoryView = customCalloutView
            }

        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
}

// MARK: - Conforming to MapViewPresenterDelegate

extension MapViewController: MapViewPresenterDelegate { }

// MARK: - Conforming to MKMapViewDelegate

extension MapViewController: MKMapViewDelegate { }

// MARK: - Conforming to CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationManager.stopUpdatingLocation()
        self.myLocation = location
        self.setupUserCurrentLocation(location)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleAuthorizationStatus(manager.authorizationStatus)
    }

    func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // Ask for permission if the status is not determined
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            // Prompt the user to enable permissions if denied or restricted
            self.promptForAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            // Start location updates if permission is granted
            self.startLocationUpdate()
        @unknown default:
            debugPrint("Unknown authorization status.")
        }
    }

    func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        handleAuthorizationStatus(locationManager.authorizationStatus)
    }

    func startLocationUpdate() {
        locationManager.startUpdatingLocation()
    }

    func promptForAuthorization() {
        self.showCancelOrSettingsAlert(title: "Location Access Denied",
                                       message: "Please enable location access in Settings to use this feature.",
                                       yesHandler: {
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        })
    }
}
