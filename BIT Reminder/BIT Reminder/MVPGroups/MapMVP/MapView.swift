//
//  MapView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 14.9.23..
//

import UIKit
import MapKit

class MapView: UIView {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var myLocationButton: UIButton!
    @IBOutlet weak var openLocationListButton: UIButton!

    func setupUI() {
        self.backgroundColor = Asset.backgroundBlueColor.color
        self.setupButtons()
        self.mapView.register(MKPinAnnotationView.self,
                              forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

    }

    private func setupButtons() {
        /// setup for myLocationButton
        self.myLocationButton.backgroundColor = Asset.backgroundBlueColor.color
        self.myLocationButton.tintColor = .white
        self.myLocationButton.layer.cornerRadius = 25
        self.myLocationButton.setImage(UIImage(systemName: "location"), for: .normal)
        /// setup for openLocationListButton
        self.openLocationListButton.backgroundColor = Asset.backgroundBlueColor.color
        self.openLocationListButton.tintColor = .white
        self.openLocationListButton.layer.cornerRadius = 25
        self.openLocationListButton.setImage(UIImage(systemName: "arrow.up.heart"), for: .normal)
    }
}
