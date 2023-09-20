//
//  FavoriteLocationsPresenter.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 19.9.23..
//

import Foundation

protocol FavoriteLocationsPresenterDelegate: AnyObject {
}

class FavoriteLocationsPresenter {

    weak var delegate: FavoriteLocationsPresenterDelegate?
    var locationList: [String] = []

    init() { }

    // MARK: - Delegate Methods

    func attachView(view: FavoriteLocationsPresenterDelegate) {
        self.delegate = view
    }

    func detachView() {
        self.delegate = nil
    }

    func getLocationList() {
        self.locationList.append(L10n.labelPharmacy)
        self.locationList.append(L10n.labelHospital)
        self.locationList.append(L10n.labelBank)
        self.locationList.append(L10n.labelAtm)
        self.locationList.append(L10n.labelLibrary)
        self.locationList.append(L10n.labelMovieTheater)
        self.locationList.append(L10n.labelGasStation)
        self.locationList.append(L10n.labelPark)
        self.locationList.append(L10n.labelBakery)
        self.locationList.append(L10n.labelPostOffice)
        self.locationList.append(L10n.labelParking)
        self.locationList.append(L10n.labelCoffyShop)
        self.locationList.append(L10n.labelMarket)
        self.locationList.append(L10n.labelPoliceStation)
        self.locationList.append(L10n.labelTheater)
        self.locationList.append(L10n.labelSportGym)
        self.locationList.append(L10n.labelBarbaque)
        self.locationList.append(L10n.labelKindergarden)
        self.locationList.append(L10n.labelSkool)
    }
}
