//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Сергей Андреев on 04.04.2023.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = L10n.Statistics.title
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private let notFoundStack = NotFoundStack(
        label: "Анализировать пока нечего",
        image: UIImage(named: "statistic_placeholder")
    )
    
    private let statisticsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    private let completedTrackersView = StatisticView(name: "Трекеров завершено")
    
    var statisticViewModel: StatisticViewModel?
    private let trackerRecordStore = TrackerRecordStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addContent()
        addConstraints()
        
        statisticViewModel?.onTrackerChange = { [weak self] trackers in
            guard let self else { return }
            self.checkContent(with: trackers)
            self.setupCompletedTrackersBlock(with: trackers.count)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statisticViewModel?.viewWillAppear()
    }
    
    private func checkContent(with tracker: [TrackerRecord]) {
        if tracker.isEmpty {
            notFoundStack.isHidden = false
            statisticsStack.isHidden = true
        } else {
            notFoundStack.isHidden = true
            statisticsStack.isHidden = false
        }
    }
    
    private func setupCompletedTrackersBlock(with count: Int) {
        completedTrackersView.setNumber(count)
    }
    
    private func addContent() {
        view.backgroundColor = .ypWhite
        view.addSubview(titleLabel)
        view.addSubview(notFoundStack)
        view.addSubview(statisticsStack)
        statisticsStack.addArrangedSubview(completedTrackersView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
          
            notFoundStack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            notFoundStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
         
            statisticsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statisticsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            statisticsStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
    

