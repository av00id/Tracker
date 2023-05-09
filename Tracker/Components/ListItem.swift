//
//  ListItem.swift
//  Tracker
//
//  Created by Сергей Андреев on 07.04.2023.
//

import UIKit

final class ListItem: UIView {
    
    private let border: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypGray
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with position: Position) {
        layer.masksToBounds = true
        layer.cornerRadius = 10
        
        switch position {
        case .first:
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            border.isHidden = false
        case .middle:
            layer.cornerRadius = 0
            border.isHidden = false
        case .last:
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .alone:
            border.isHidden = true
            layer.maskedCorners = [
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner,
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner
            ]
        }
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 16
        backgroundColor = .ypBackgroundDay
        
        addSubview(border)
        
        NSLayoutConstraint.activate([
            border.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            border.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            border.bottomAnchor.constraint(equalTo: bottomAnchor),
            border.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}

extension ListItem {
    enum Position {
        case first, middle, last, alone
    }
    
    static let height: CGFloat = 75
}
