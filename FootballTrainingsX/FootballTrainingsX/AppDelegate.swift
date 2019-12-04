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
    let tabBarImageSize = CGSize(width: 30, height: 30)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CoreDataStack.shared.firstLaunchSettings()
        setupControllers()
        return true
    }
    
    private func setupControllers() {
        let trainingsListVC = ExerciseListViewController()
        
        let navigationController = UINavigationController(rootViewController: trainingsListVC)
        navigationController.navigationBar.barStyle = .black
        let listImage = UIImage(named: "list")?.scaledTo(size: tabBarImageSize)
        navigationController.tabBarItem = UITabBarItem(title: nil, image: listImage, tag: 0)
    
        let statsVC = StatsViewController()
        let statsImage = UIImage(named: "stats")?.scaledTo(size: tabBarImageSize)
        statsVC.tabBarItem = UITabBarItem(title: nil, image: statsImage, tag: 1)
    
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barStyle = .black
        tabBarController.viewControllers = [navigationController, statsVC]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
}

