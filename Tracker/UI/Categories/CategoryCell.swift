//
//  CategoryCell.swift
//  Tracker
//
//  Created by Сергей Андреев on 05.05.2023.
//

import UIKit

final class CategoryCell: UITableViewCell {
    
    private lazy var listItem = ListItem()
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private let checkmarkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "checkmark")
        return imageView
    }()
    
    static let identifier = "WeekdayCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addContent()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with label: String, isSelected: Bool, position: ListItem.Position) {
        listItem.configure(with: position)
        self.label.text = label
        checkmarkImage.isHidden = !isSelected
    }
    
    private func addContent() {
        selectionStyle = .none
        contentView.addSubview(listItem)
        contentView.addSubview(label)
        contentView.addSubview(checkmarkImage)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
            listItem.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            listItem.topAnchor.constraint(equalTo: contentView.topAnchor),
            listItem.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            listItem.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            label.leadingAnchor.constraint(equalTo: listItem.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: listItem.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: listItem.trailingAnchor, constant: -83),
            
            checkmarkImage.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            checkmarkImage.trailingAnchor.constraint(equalTo: listItem.trailingAnchor, constant: -16)
        ])
    }
}
