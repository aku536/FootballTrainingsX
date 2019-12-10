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
    var tabBarCoordinator: TabBarCoordinator?
    var exerciseCoordinator: ExerciseCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CoreDataStack.shared.firstLaunchSettings(userDefaults: UserDefaults.standard)
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
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barStyle = .black
        
        let exerciseListVC = ExerciseListViewController(model: model)
        let exerciseVC = ExerciseViewController(exerciseModel: model, calculator: percentageCalculator)
        let statsVC = StatsViewController(exerciseModel: model, percentageCalculator: percentageCalculator)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        tabBarCoordinator = TabBarCoordinator(tabBarVC: tabBarController, viewController: statsVC)
        tabBarCoordinator?.setup()
        
        exerciseCoordinator = ExerciseCoordinator(exerciseListVC: exerciseListVC, exerciseVC: exerciseVC)
        exerciseCoordinator?.navigationController = tabBarCoordinator?.navigationController
        exerciseCoordinator?.start()
    }
    
    // Отображение статистики по полученной голосовой команде
    private func handleShowExerciseActivity() {
        tabBarCoordinator?.showStatsVC()
    }
    
}

