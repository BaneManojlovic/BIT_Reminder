//
//  UIImageView+Image.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 18.9.23..
//

import UIKit

extension UIImageView {

    // MARK: - Helpers for converting URLs to images
    func convertToUIImageFromURL(_ picture: String?) {
        if let image = picture {
            if let imageUrl = URL(string: image) {
                /// part of the task put on background thread
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageUrl)
                    /// go back to main thread
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data!)
                    }
                }
            }
        }
    }
}
