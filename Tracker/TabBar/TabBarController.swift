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
        tabBar.backgroundColor = .white
        tabBar.tintColor = .blue
        
        let trackerViewController = TrackersViewController()
        let statisticViewController = StatisticViewController()
        
        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "tab_bar_circle"),
            selectedImage: nil
        )
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "tab_bar_statistic"),
            selectedImage: nil)
        
        let controllers = [trackerViewController , statisticViewController]
        
        viewControllers = controllers
        
    }
}
