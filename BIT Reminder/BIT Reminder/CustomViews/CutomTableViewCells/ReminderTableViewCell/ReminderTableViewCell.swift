//
//  ReminderTableViewCell.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 13.9.23..
//

import UIKit

class ReminderTableViewCell: UITableViewCell {

    @IBOutlet weak var smallBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var importanceImage: UIImageView!

    // MARK: - Properties
    static let reuseIdentifier = "ReminderTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupUI()
    }

    func setupUI() {
        self.clipsToBounds = true
        selectionStyle = .none
        self.backgroundColor = Asset.backgroundBlueColor.color
        self.setupLabels()
        self.smallBackgroundView.layer.cornerRadius = 10
    }

    private func setupLabels() {
        self.titleLabel.textAlignment = .left
        self.titleLabel.textColor = .white

        self.dateLabel.textAlignment = .left
        self.dateLabel.textColor = .white
    }

    func fillCellWithData(model: Reminder) {
        self.titleLabel.text = model.title
        self.dateLabel.text = formatDateToShow(date: model.date ?? "")
        self.importanceImage.tintColor = .yellow
        if let important = model.important, important {
            self.importanceImage.isHidden = false
            self.importanceImage.image = UIImage(systemName: "star.fill")?.withTintColor(.yellow)
        } else {
            self.importanceImage.isHidden = true
        }
        debugPrint("--- \(model)")
    }

    func formatDateToShow(date: String) -> String {
        let formatter = DateFormatter()
        /// format String to date
        formatter.dateFormat = "yyyy-MM-dd"
        guard let firstDate = formatter.date(from: date) else { return "" }
        /// reformat date to String
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: firstDate)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.mm.yyyy"
        return formatter.string(from: date)
    }

}
