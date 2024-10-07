//
//  UIVewController+Alerts.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 12.9.23..
//

import UIKit

extension UIViewController {
    /// Ok Alert pop-up
    func showOkAlert(title: String? = nil,
                     message: String,
                     confirmation: (() -> Void)? = nil,
                     completion: (() -> Void)? = nil) {

        let okAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        okAlert.addAction(UIAlertAction(title: L10n.alertButtonTitleOkUppercased,
                                        style: .default,
                                        handler: { _ in
            confirmation?()
        }))

        self.present(okAlert, animated: true, completion: completion)
    }
    /// Cancel or Yes Alert pop-up
    func showCancelOrYesAlert(title: String? = L10n.alertTitleAlert,
                              message: String,
                              yesHandler: @escaping (() -> Void),
                              noHandler: (() -> Void)? = nil,
                              completion: (() -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: L10n.alertButtonTitleCancel,
                                      style: .cancel,
                                      handler: { _ in
            noHandler?()
        }))
        alert.addAction(UIAlertAction(title: L10n.alertButtonTitleYes,
                                      style: .default,
                                      handler: { _ in
            yesHandler()
        }))

        self.present(alert, animated: true, completion: completion)
    }
    /// No or Yes Alert pop-up
    func showNoOrYesAlert(title: String? = L10n.alertTitleAlert,
                          message: String,
                          yesHandler: @escaping (() -> Void),
                          noHandler: (() -> Void)? = nil,
                          completion: (() -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: L10n.alertButtonTitleNo,
                                      style: .cancel,
                                      handler: { _ in
            noHandler?()
        }))
        alert.addAction(UIAlertAction(title: L10n.alertButtonTitleYes,
                                      style: .default,
                                      handler: { _ in
            yesHandler()
        }))

        self.present(alert, animated: true, completion: completion)
    }
    
    /// Cancel or Yes Alert pop-up
    func showCancelOrSettingsAlert(title: String? = L10n.alertTitleAlert,
                              message: String,
                              yesHandler: @escaping (() -> Void),
                              noHandler: (() -> Void)? = nil,
                              completion: (() -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: L10n.alertButtonTitleCancel,
                                      style: .cancel,
                                      handler: { _ in
            noHandler?()
        }))
        alert.addAction(UIAlertAction(title: L10n.titleLabelSettings,
                                      style: .default,
                                      handler: { _ in
            yesHandler()
        }))

        self.present(alert, animated: true, completion: completion)
    }
}
