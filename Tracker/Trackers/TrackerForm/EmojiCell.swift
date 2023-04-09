//
//  EmojiCell.swift
//  Tracker
//
//  Created by Сергей Андреев on 07.04.2023.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32)
        return label
    }()
    
    static let identifier = "EmojiCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupContent()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with label: String) {
        emojiLabel.text = label
    }
    
    func select() {
        contentView.backgroundColor = .lightGray
    }
    
    func deselect() {
        contentView.backgroundColor = .clear
    }
}

private extension EmojiCell {
    func setupContent() {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        contentView.addSubview(emojiLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
