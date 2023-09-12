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

        okAlert.addAction(UIAlertAction(title: "OK",
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

        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: { _ in
            noHandler?()
        }))
        alert.addAction(UIAlertAction(title: "Yes",
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

        alert.addAction(UIAlertAction(title: "No",
                                      style: .cancel,
                                      handler: { _ in
            noHandler?()
        }))
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: .default,
                                      handler: { _ in
            yesHandler()
        }))

        self.present(alert, animated: true, completion: completion)
    }
}
