//
//  TabBarController.swift
//  Tracker
//
//  Created by Сергей Андреев on 04.04.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .ypWhite
        tabBar.tintColor = .ypBlue
        
        let trackerViewController = TrackersViewController()
        let statisticViewController = StatisticViewController()
        let statisticViewModel = StatisticViewModel()
        statisticViewController.statisticViewModel = statisticViewModel
        
        trackerViewController.tabBarItem = UITabBarItem(
            title: L10n.Tabbar.trackers,
            image: UIImage(named: "tab_bar_circle"),
            selectedImage: nil
        )
        statisticViewController.tabBarItem = UITabBarItem(
            title: L10n.Tabbar.statistics,
            image: UIImage(named: "tab_bar_statistic"),
            selectedImage: nil)
        
        let controllers = [trackerViewController , statisticViewController]
        
        viewControllers = controllers
        
    }
}
