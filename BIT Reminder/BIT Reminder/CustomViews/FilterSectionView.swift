//
//  FilterSectionView.swift
//  BIT Reminder
//
//  Created by suncica on 29.7.24..
//

import UIKit

class FilterSectionView: UITableViewHeaderFooterView {

    static let identifier = "FilterSectionView"

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }

    func configure(with title: String) {
        self.titleLabel.text = title
        self.setupUI()
    }

    private func setupUI() {
        let sectionView = UIView()
        sectionView.backgroundColor = Asset.backgroundBlueColor.color
        self.backgroundView = sectionView

        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
