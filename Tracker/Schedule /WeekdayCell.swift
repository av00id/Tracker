//
//  WeekdayCell.swift
//  Tracker
//
//  Created by Сергей Андреев on 07.04.2023.
//

import UIKit

protocol WeekdayCellDelegate: AnyObject {
    func didToggleSwitchView(to isSelected: Bool, of weekday: Weekday)
}

final class WeekdayCell: UITableViewCell {
    
    private lazy var listItem = ListItem()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private lazy var switchView: UISwitch = {
        let switchView = UISwitch()
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.onTintColor = .ypBlue
        switchView.addTarget(self, action: #selector(didToggleSwitchView), for: .valueChanged)
        return switchView
    }()
    
    static let identifier = "WeekdayCell"
    weak var delegate: WeekdayCellDelegate?
    private var weekday: Weekday?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupContent()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didToggleSwitchView(_ sender: UISwitch) {
        guard let weekday else { return }
        delegate?.didToggleSwitchView(to: sender.isOn, of: weekday)
    }
    
    func configure(with weekday: Weekday, isSelected: Bool, position: ListItem.Position) {
        self.weekday = weekday
        listItem.configure(with: position)
        nameLabel.text = weekday.rawValue
        switchView.isOn = isSelected
    }
    
    private func setupContent() {
        selectionStyle = .none
        contentView.addSubview(listItem)
        contentView.addSubview(nameLabel)
        contentView.addSubview(switchView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            listItem.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            listItem.topAnchor.constraint(equalTo: contentView.topAnchor),
            listItem.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            listItem.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: listItem.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: listItem.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: listItem.trailingAnchor, constant: -83),
            
            switchView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            switchView.trailingAnchor.constraint(equalTo: listItem.trailingAnchor, constant: -16)
        ])
    }
}
