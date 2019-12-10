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
    var stack: CoreDataProtocol
    var presentedExerciseIndex: Int? // Индекс выбранного упражнения
    var networkWorker: NetworkWorker
    var fileManager: FileManager
    
    init(stack: CoreDataProtocol, networkWorker: NetworkWorker, fileManager: FileManager) {
        self.stack = stack
        self.networkWorker = networkWorker
        self.fileManager = fileManager
        exercisesList = stack.loadFromMemory()
    }
    
    /// Сохранение результатов упражнения
    ///
    /// - Parameter exercise: упражнение
    func save(_ exercise: Exercise) {
        stack.save(exercise)
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
    
    /// Загружает видео по ссылке и сохраняет его на устройстве
    ///
    /// - Parameters:
    ///   - url: ссылка на видео
    ///   - completion: возвращает ссылку на локально сохраненное видео
    func saveToFileManager(with url: URL, completion: @escaping (String?) -> Void) {
        guard let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            completion(nil)
            return
        }
        let localPath = documentsDirectoryURL.appendingPathComponent(url.lastPathComponent).path
        
        if !fileManager.fileExists(atPath: localPath) {
            networkWorker.downloadVideo(with: url) { (location, response) in
                guard let location = location, let response = response else {
                    completion(nil)
                    return
                }
                let destinationURL = documentsDirectoryURL.appendingPathComponent(response.suggestedFilename ?? url.lastPathComponent)
                do {
                    try self.fileManager.moveItem(at: location, to: destinationURL)
                    completion(destinationURL.absoluteString)
                } catch {
                    print(error)
                }
            }
        } else {
            do {
                try fileManager.removeItem(atPath: localPath)
                completion(nil)
            } catch {
                print(error)
            }
        }
    }
}
