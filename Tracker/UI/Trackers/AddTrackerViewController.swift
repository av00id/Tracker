//
//  AddTrackersViewController.swift
//  Tracker
//
//  Created by Сергей Андреев on 04.04.2023.
//

import UIKit

protocol AddTrackerViewControllerDelegate: AnyObject {
    func didSelectTracker(with: AddTrackerViewController.TrackerType)
}

final class AddTrackerViewController: UIViewController {
    
    private lazy var addHabitButton: UIButton = {
        let button = Button(title: "Привычка")
        button.addTarget(self, action: #selector(didTapAddHabitButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var addIrregularEventButton: UIButton = {
        let button = Button(title: "Нерегулярное событие")
        button.addTarget(self, action: #selector(didTapAddIrregularEventButton), for: .touchUpInside)
        return button
    }()
    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    weak var delegate: AddTrackerViewControllerDelegate?
    
    private var labelText = ""
    private var category: String?
    private var schedule: [Weekday]?
    private var emoji: String?
    private var color: UIColor?
    
    private var isConfirmButtonEnabled: Bool {
        labelText.count > 0 && !isValidationMessageVisible
    }
    
    private var isValidationMessageVisible = false
    private var parametrs = ["Категория", "Расписание"]
    private let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪",
    ]
    private let colors = UIColor.selection 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addContent()
        addConstraints()
        
    }
    
    private func addContent() {
        title = "Создание трекера"
        view.backgroundColor = .ypWhite
        
        view.addSubview(buttonsStack)
        
        buttonsStack.addArrangedSubview(addHabitButton)
        buttonsStack.addArrangedSubview(addIrregularEventButton)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            
            buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            addHabitButton.heightAnchor.constraint(equalToConstant: 60),
            
            addIrregularEventButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc
    private func didTapAddHabitButton() {
        title = "Новая привычка"
        delegate?.didSelectTracker(with: .habit)
    }
    
    @objc
    private func didTapAddIrregularEventButton() {
        delegate?.didSelectTracker(with: .irregularEvent)
    }
}

extension AddTrackerViewController {
    enum TrackerType {
        case habit, irregularEvent
    }
}
