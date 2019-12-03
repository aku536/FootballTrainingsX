//
//  CoreDataStack.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 26/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    /// Синглтон
    static let shared: CoreDataStack = {
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Training")
        do {
            guard let trainings = try managedContext.fetch(fetchRequest) as? [MOTraining] else {
                return []
            }
            for training in trainings {
                let type = training.value(forKey: "type") as? String ?? ""
                let trainingDescription = training.value(forKey: "trainingDescription") as? String ?? ""
                let numberOfReps = training.value(forKey: "numberOfReps") as? Int16 ?? 0
                let successfulReps = training.value(forKey: "successfulReps") as? Int16 ?? 0
                let urlString = training.value(forKey: "urlString") as? String ?? ""
                let loadedTraining = Exercise(type: type, trainingDescription: trainingDescription, numberOfReps: numberOfReps, successfulReps: successfulReps, urlString: urlString)
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
        try! persistentContainer.viewContext.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "Training")))
    }
    
    /// Сохранение тренировок в память
    ///
    /// - Parameter training: футбольное упражнение
    func save(_ training: Exercise) {
        persistentContainer.performBackgroundTask { (context) in
            self.clearData()
            let objectToSave = MOTraining(context: context)
            objectToSave.type = training.type
            objectToSave.trainingDescription = training.trainingDescription
            objectToSave.urlString = training.urlString
            objectToSave.numberOfReps = training.numberOfReps
            objectToSave.successfulReps = training.successfulReps
            try? context.save()
        }
    }
    
    /// Загрузка дефолтных значений из хранилища при первом запуске приложения
    func firstLaunchSettings() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore {
            clearData()
            persistentContainer.performBackgroundTask { (context) in
                
                let shortPass = MOTraining(context: context)
                shortPass.type = "Короткий пас"
                shortPass.trainingDescription = "   Передача мяча в парах в одно - два касания. Расстояние между партнёрами 2 – 3 м. Это упражнение можно делать и без партнёра перед стенкой. Главная задача, контроль положения корпуса и стопы, точность передачи."
                shortPass.urlString = "https://firebasestorage.googleapis.com/v0/b/footballtrainingsx.appspot.com/o/foottrain.mp4?alt=media&token=f647c539-13d9-460e-b402-ff3e3b17f7d7"
                
                let shot = MOTraining(context: context)
                shot.type = "Удар"
                shot.trainingDescription = "   Удар по воротам при статическом положении мяча. Сперва, делается серия ударов в правый угол ворот. После можно приступать к ударам в левый угол. Заключительной частью данного упражнения является чередование ударов в разные углы."
                shot.urlString = "https://firebasestorage.googleapis.com/v0/b/footballtrainingsx.appspot.com/o/ronaldo.mp4?alt=media&token=10dcc822-f48f-48c6-8454-d798ae4749a2"
                
                try? context.save()
            }
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        //UserDefaults.standard.set(false, forKey: "launchedBefore") // для перезагрузки дефолтных значений
    }
    
}
