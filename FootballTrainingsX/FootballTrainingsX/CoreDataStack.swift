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
    func loadFromMemory() -> [MOTraining] {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Training")
        var trainings = [MOTraining]()
        do {
            trainings = try managedContext.fetch(fetchRequest) as! [MOTraining]
            return trainings
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    /// Очистка сохраненных изображений
    func clearData() {
        try! persistentContainer.viewContext.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "Training")))
    }
    
    /// Сохранение тренировок в
    ///
    /// - Parameter trainings: массив футбольных тренировок
    func save(_ trainings: [MOTraining]) {
        clearData()
        persistentContainer.performBackgroundTask { (context) in
            for trainingToSave in trainings {
                let training = MOTraining(context: context)
                training.type = trainingToSave.type
                training.trainingDescription = trainingToSave.trainingDescription
                training.urlString = trainingToSave.urlString
                training.numberOfReps = trainingToSave.numberOfReps
                try? context.save()
            }
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
