//
//  ExerciseCoordinator.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 09/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

/// Работа с отображением списка упражнений и подробного представления
class ExerciseCoordinator {
    
    var navigationController: UINavigationController?
    var exerciseListVC: ExerciseSelectionProtocol
    var exerciseVC: UIViewController
    
    init(exerciseListVC: ExerciseSelectionProtocol, exerciseVC: UIViewController) {
        self.exerciseListVC = exerciseListVC
        self.exerciseVC = exerciseVC
    }
    
    /// Устанавливает колбэк и презентует представление со списком упражнений
    func start() {
        exerciseListVC.onExerciseSelect = { [weak self] in
            self?.presentExerciseViewController()
        }
        guard let exerciseListVC = exerciseListVC as? UIViewController else { return }
        navigationController?.pushViewController(exerciseListVC, animated: true)
    }
    
    /// Отображает ExerciseViewController, когда вызывается колбэк у ExerciseListViewController
    private func presentExerciseViewController() {
        navigationController?.pushViewController(exerciseVC, animated: true)
    }
    
}


