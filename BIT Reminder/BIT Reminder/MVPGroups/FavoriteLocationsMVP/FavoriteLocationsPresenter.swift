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
        self.locationList.append("apoteka")
        self.locationList.append("bolnica")
        self.locationList.append("banka")
        self.locationList.append("bankomat")
        self.locationList.append("biblioteka")
        self.locationList.append("bioskop")
        self.locationList.append("benzinska stanica")
        self.locationList.append("park")
        self.locationList.append("pekara")
        self.locationList.append("pošta")
        self.locationList.append("parking")
        self.locationList.append("kafe")
        self.locationList.append("pijaca")
        self.locationList.append("policija")
        self.locationList.append("pozorište")
        self.locationList.append("teretana")
        self.locationList.append("roštilj")
        self.locationList.append("vrtić")
        self.locationList.append("škola")
    }
}
