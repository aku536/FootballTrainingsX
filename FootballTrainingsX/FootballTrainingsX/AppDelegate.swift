//
//  AppDelegate.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 25/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        CoreDataStack.shared.firstLaunchSettings()
        
        let trainingsListVC = ExerciseListViewController()
        let navigationController = UINavigationController(rootViewController: trainingsListVC)
        navigationController.navigationBar.barStyle = .black
        navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 1)
        
        let statsVC = StatsViewController()
        statsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 2)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barStyle = .black
        tabBarController.viewControllers = [navigationController, statsVC]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
    
}

