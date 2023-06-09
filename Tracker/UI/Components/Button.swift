//
//  Button.swift
//  Tracker
//
//  Created by Сергей Андреев on 04.04.2023.
//

import UIKit

final class Button: UIButton {
    convenience init(color: UIColor = .ypBlack, titleColor:  UIColor = .ypWhite, title: String) {
        self.init(type: .system)
        
        setTitle(title, for: .normal)
        backgroundColor = color
        
        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        layer.cornerRadius = 24
    }
    
    static func danger(title: String) -> Self {
        let button = self.init(color: .clear, title: title)
        
        button.setTitleColor(.ypRed, for: .normal)
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.borderWidth = 1
        
        return button
    }
}
