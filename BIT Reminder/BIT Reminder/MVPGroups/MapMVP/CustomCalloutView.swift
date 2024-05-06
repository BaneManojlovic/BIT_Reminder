//
//  CustomCalloutView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 15.1.24..
//

import Foundation
import UIKit

class CustomCalloutView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.systemBlue
        label.isUserInteractionEnabled = true
        return label
    }()

    var phoneNumber: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureGesture()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
        configureGesture()
    }

    private func configureSubviews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(subtitleLabelTapped))
        self.addGestureRecognizer(tapGesture)
    }

    @objc private func subtitleLabelTapped() {
        if let phoneNumber = phoneNumber {
            if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    func configure(withTitle title: String?, subtitle: String?, phoneNumber: String?) {
        titleLabel.text = title ?? ""
        subtitleLabel.text = subtitle
        self.phoneNumber = phoneNumber
    }
}
