//
//  ExerciseModel.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 09/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import Foundation

/// Модель упражнений
class ExerciseModel {
    /// Массив содержащий список всех упражнений
    var exercisesList: [Exercise]
    var stack: CoreDataStack
    var presentedExerciseIndex: Int? // Индекс выбранного упражнения
    
    init(stack: CoreDataStack) {
        self.stack = stack
        exercisesList = stack.loadFromMemory()
    }
    
    /// Обнуление статистики
    func resetStats() {
        for index in exercisesList.indices {
            exercisesList[index].numberOfReps = 0
            exercisesList[index].successfulReps = 0
            save(exercisesList[index])
        }
    }
    
    /// Сохранение резултатов упражнения
    ///
    /// - Parameter exercise: упражнение
    func save(_ exercise: Exercise) {
        stack.save(exercise)
        exercisesList = stack.loadFromMemory()
    }
    
}
