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
    var tabBarController: UITabBarController?
    var statsVC: StatsViewController?
    var coordinator: ExerciseCoordinator?
    
    let tabBarImageSize = CGSize(width: 30, height: 30)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CoreDataStack.shared.firstLaunchSettings()
        setupControllers()
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == "com.krrl.FootballTrainingsX.showStats" {
            // Обрабатываем событие так, как нам это надо
            handleShowExerciseActivity()
            return true
        }
        return false
    }
    
    // Настройка контроллеров
    private func setupControllers() {
        let stack = CoreDataStack.shared
        let networkWorker = NetworkWorker()
        let model = ExerciseModel(stack: stack, networkWorker: networkWorker, fileManager: FileManager.default)
        let percentageCalculator = PercentageCalculator()
        
        let exerciseListVC = ExerciseListViewController(model: model)
        
        let navigationController = UINavigationController(rootViewController: exerciseListVC)
        navigationController.navigationBar.barStyle = .black
        let listImage = UIImage(named: "list")?.scaledTo(size: tabBarImageSize)
        navigationController.tabBarItem = UITabBarItem(title: nil, image: listImage, tag: 0)
        
        coordinator = ExerciseCoordinator(navigationController: navigationController, exerciseListVC: exerciseListVC, exerciseModel: model)
    
        statsVC = StatsViewController(exerciseModel: model, percentageCalculator: percentageCalculator)
        guard let statsVC = statsVC else { return }
        let statsImage = UIImage(named: "stats")?.scaledTo(size: tabBarImageSize)
        statsVC.tabBarItem = UITabBarItem(title: nil, image: statsImage, tag: 1)
    
        tabBarController = UITabBarController()
        tabBarController?.tabBar.barStyle = .black
        tabBarController?.viewControllers = [navigationController, statsVC]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    // Отображение статистики по полученной голосовой команде
    private func handleShowExerciseActivity() {
        tabBarController?.selectedViewController = statsVC
    }
    
}

