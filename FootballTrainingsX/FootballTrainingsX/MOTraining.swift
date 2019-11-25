//
//  MOTraining.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 26/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import Foundation
import CoreData

@objc(MOTraining)
internal class MOTraining: NSManagedObject {
    
    @NSManaged var type: String // Название тренировки
    @NSManaged var trainingDescription: String // Описание
    @NSManaged var numberOfReps: Int16 // Количество повторений
    @NSManaged var successfulReps: Int16 // Количество успешных повторений
    @NSManaged var urlString: String // Ссылка на видео

}
