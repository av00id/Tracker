//
//  TrackerCell.swift
//  Tracker
//
//  Created by Сергей Андреев on 04.04.2023.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func didTapCompleteButton(of cell: TrackerCell, with tracker: Tracker)
    
}

final class TrackerCell: UICollectionViewCell {
    
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor(red: 174 / 255, green: 175 / 255, blue: 180 / 255, alpha: 0.3).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let iconView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        return view
    }()
    
    private let emoji: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let trackerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    private let daysCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .systemBackground//UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        return button
    }()
    
    private let analyticService = AnalyticService()
    
    static let identifier = "TrackerCell"
    weak var delegate: TrackerCellDelegate?
    private var tracker: Tracker?
    private var days = 0 {
        willSet {
            daysCountLabel.text = L10n.numberOfDays(newValue)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addContent()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tracker = nil
        days = 0
        completeButton.setImage(UIImage(systemName: "plus"), for: .normal)
        completeButton.layer.opacity = 1
    }
    
    func configure(
        with tracker: Tracker,
        days: Int,
        isCompleted: Bool,
        interaction: UIInteraction
    ) {
        self.tracker = tracker
        self.days = days
        cardView.backgroundColor = tracker.color
        cardView.addInteraction(interaction)
        emoji.text = tracker.emoji
        trackerLabel.text = tracker.label
        completeButton.backgroundColor = tracker.color
        toggleCompletedButton(to: isCompleted)
    }
    
    func toggleCompletedButton(to isCompleted: Bool) {
        if isCompleted {
            completeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            completeButton.layer.opacity = 0.3
        } else {
            completeButton.setImage(UIImage(systemName: "plus"), for: .normal)
            completeButton.layer.opacity = 1
        }
    }
    
    func increaseCount() {
        days += 1
    }
    
    func decreaseCount() {
        days -= 1
    }
    
    private func addContent() {
        contentView.addSubview(cardView)
        cardView.addSubview(iconView)
        cardView.addSubview(emoji)
        cardView.addSubview(trackerLabel)
        contentView.addSubview(daysCountLabel)
        contentView.addSubview(completeButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
            
            iconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            iconView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),
            
            emoji.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            
            trackerLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            trackerLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            trackerLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            daysCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysCountLabel.centerYAnchor.constraint(equalTo: completeButton.centerYAnchor),
            daysCountLabel.trailingAnchor.constraint(equalTo: completeButton.leadingAnchor, constant: -8),
            
            completeButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.heightAnchor.constraint(equalTo: completeButton.widthAnchor),
        ])
    }
    
    @objc
    private func didTapCompleteButton() {
        analyticService.report(event: AnalyticEventNames.click, params: ["screen": AnalyticScreenNames.trackers,
                                                                         "item": AnalyticItemNames.completeTrack])
        
        guard let tracker else { return }
        delegate?.didTapCompleteButton(of: self, with: tracker)
    }
}


