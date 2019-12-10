//
//  TabBarCoordinator.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 11/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

/// Работа и настройка TabBarController
class TabBarCoordinator {
    
    private var tabBarController: UITabBarController
    private var viewController: UIViewController
    var navigationController: UINavigationController?
    private let tabBarImageSize = CGSize(width: 30, height: 30)
    
    init(tabBarVC: UITabBarController, viewController: UIViewController) {
        self.tabBarController = tabBarVC
        self.viewController = viewController
    }
    
    /// Настройка TabBarController
    func setup() {
        navigationController = UINavigationController()
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.barStyle = .black
        let listImage = UIImage(named: "list")?.scaledTo(size: tabBarImageSize)
        navigationController.tabBarItem = UITabBarItem(title: nil, image: listImage, tag: 0)
        
        let statsImage = UIImage(named: "stats")?.scaledTo(size: tabBarImageSize)
        viewController.tabBarItem = UITabBarItem(title: nil, image: statsImage, tag: 1)
        
        tabBarController.viewControllers = [navigationController, viewController]
    }
    
    /// Отображение второй вкладки
    func showStatsVC() {
        tabBarController.selectedViewController = viewController
    }
}
