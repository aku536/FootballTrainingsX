//
//  ExerciseCoordinator.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 09/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

/// Создает и экран упражнения, когда оно выбрано
class ExerciseCoordinator {
    
    var navigationController: UINavigationController
    var exerciseListVC: ExerciseListViewController
    var exerciseModel: ExerciseModel
    var networkWorker: NetworkWorker
    
    init(navigationController: UINavigationController, exerciseListVC: ExerciseListViewController, exerciseModel: ExerciseModel, networkWorker: NetworkWorker) {
        self.navigationController = navigationController
        self.exerciseListVC = exerciseListVC
        self.exerciseModel = exerciseModel
        self.networkWorker = networkWorker
        exerciseListVC.onExerciseSelect = { [weak self] in
            self?.presentExerciseViewController()
        }
    }
    
    private func presentExerciseViewController() {
        let exerciseVC = ExerciseViewController(exerciseModel: exerciseModel, calculator: PercentageCalculator(), networkWorker: networkWorker)
        navigationController.pushViewController(exerciseVC, animated: true)
    }
    
}
