//
//  CoreDataStack.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 26/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataProtocol {
    static var shared: CoreDataProtocol { get }
    func loadFromMemory() -> [Exercise]
    func save(_ exercise: Exercise)
    func firstLaunchSettings()
}

final class CoreDataStack: CoreDataProtocol {
    
    /// Синглтон
    static let shared: CoreDataProtocol = {
        let shared = CoreDataStack()
        return shared
    }()
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "TrainingModel")
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    var persistentContainer: NSPersistentContainer
    
    /// Загружаем имеющиеся данные из памяти
    ///
    /// - Returns: возвращаем массив с Футбольными тренировками
    func loadFromMemory() -> [Exercise] {
        var loadedTrainings = [Exercise]()
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Exercise")
        do {
            guard let trainings = try managedContext.fetch(fetchRequest) as? [MOExercise] else {
                return []
            }
            for training in trainings {
                let type = training.value(forKey: "type") as? String ?? ""
                let exerciseDescription = training.value(forKey: "exerciseDescription") as? String ?? ""
                let numberOfReps = training.value(forKey: "numberOfReps") as? Int16 ?? 0
                let successfulReps = training.value(forKey: "successfulReps") as? Int16 ?? 0
                let urlString = training.value(forKey: "urlString") as? String ?? ""
                let localURLString = training.value(forKey: "localURLString") as? String
                let loadedTraining = Exercise(type: type, exerciseDescription: exerciseDescription, numberOfReps: numberOfReps, successfulReps: successfulReps, urlString: urlString, localURLString: localURLString)
                loadedTrainings.append(loadedTraining)
            }
            return loadedTrainings
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    /// Очистка сохраненных изображений
    func clearData() {
        do {
            try persistentContainer.viewContext.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "Exercise")))
        } catch {
            print("Не удалось очистить память")
        }
    }
    
    /// Сохранение тренировок в память
    ///
    /// - Parameter training: футбольное упражнение
    func save(_ exercise: Exercise) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Exercise")
        do {
            guard let exercises = try managedContext.fetch(fetchRequest) as? [MOExercise] else {
                return
            }
            for loadedExercise in exercises {
                if loadedExercise.type == exercise.type {
                    loadedExercise.numberOfReps = exercise.numberOfReps
                    loadedExercise.successfulReps = exercise.successfulReps
                    loadedExercise.localURLString = exercise.localURLString
                    try? managedContext.save()
                }
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return
        }
    }
    
    /// Загрузка дефолтных значений из хранилища при первом запуске приложения
    func firstLaunchSettings() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore {
            clearData()
            persistentContainer.performBackgroundTask { (context) in
                
                let shortPass = MOExercise(context: context)
                shortPass.type = "Короткий пас"
                shortPass.exerciseDescription = "   Передача мяча в парах в одно касание. Расстояние между партнёрами 2 – 3 м. Это упражнение можно делать и без партнёра перед стенкой. Главная задача, контроль положения корпуса и стопы, точность передачи."
                shortPass.urlString = "https://firebasestorage.googleapis.com/v0/b/footballtrainingsx.appspot.com/o/shortpass.mp4?alt=media&token=d39b7cd6-05e0-4b02-85d2-b252c520e0ae"
                
                let shot = MOExercise(context: context)
                shot.type = "Удар"
                shot.exerciseDescription = "   Удар по воротам при статическом положении мяча. Сперва, делается серия ударов в правый угол ворот. После можно приступать к ударам в левый угол. Заключительной частью данного упражнения является чередование ударов в разные углы."
                shot.urlString = "https://firebasestorage.googleapis.com/v0/b/footballtrainingsx.appspot.com/o/freekicks.mov?alt=media&token=a21ffa23-e84f-4b4e-b3ba-b524d8d6950e"
                
                let reverse = MOExercise(context: context)
                reverse.type = "Разворот"
                reverse.exerciseDescription = "   Игрок получает мяч от партнера, подрабатывает его в сторону и возвращает партнеру. После этого разворачивается на 180 градусов. Это помогает оставаться сосредоточенным в игре и быть готовым к открываниям."
                reverse.urlString = "https://firebasestorage.googleapis.com/v0/b/footballtrainingsx.appspot.com/o/180.mp4?alt=media&token=33634dd3-f303-4529-b609-f04f04dd5016"
                
                let shortpass2 = MOExercise(context: context)
                shortpass2.type = "Пас в 2 касания"
                shortpass2.exerciseDescription = "   Передача мяча в парах в два касание. Расстояние между партнёрами 2 – 3 м. Главная задача, контроль положения корпуса и стопы, точность передачи."
                shortpass2.urlString = "https://firebasestorage.googleapis.com/v0/b/footballtrainingsx.appspot.com/o/2shortpass.mp4?alt=media&token=91a7249b-4413-40bd-91d0-414afb6b10d3"
                
                let snake = MOExercise(context: context)
                snake.type = "Пас в движении"
                snake.exerciseDescription = "   5-6 фишек размещены в ряд. Игроки делают передачи друг другу в 1-2 касания, находясь при этом в движении."
                snake.urlString = "https://firebasestorage.googleapis.com/v0/b/footballtrainingsx.appspot.com/o/snake.mp4?alt=media&token=d5842d80-bdb9-47b9-9a31-153f6ede8785"
                
                let longpass = MOExercise(context: context)
                longpass.type = "Длинный пас"
                longpass.exerciseDescription = "   Расстояние между игроками 10 м. Перед ними ворота из фишек 1 м. Задача выполнить передачу партнеру через ворота. Отрабатывается точность длинной перердачи"
                longpass.urlString = "https://firebasestorage.googleapis.com/v0/b/footballtrainingsx.appspot.com/o/longpass.mp4?alt=media&token=20cb5600-1699-4707-81f4-c032b4b490bb"
                
                let corridor = MOExercise(context: context)
                corridor.type = "Коридор"
                corridor.exerciseDescription = "   4 фишки расположены полукругом, образуя 3 коридора. Игрок отдающий передачу показывает в какой коридор должен открыться напарник."
                corridor.urlString = "https://firebasestorage.googleapis.com/v0/b/footballtrainingsx.appspot.com/o/coridor.mp4?alt=media&token=9cb95483-9cf6-4542-bf1e-40a0cf67b664"
                
                try? context.save()
            }
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        //UserDefaults.standard.set(false, forKey: "launchedBefore") // для перезагрузки дефолтных значений
    }
    
}
