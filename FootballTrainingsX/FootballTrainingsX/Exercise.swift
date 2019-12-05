//
//  Training.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 03/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import Foundation

struct Exercise {
    
    var type: String // Название тренировки
    var exerciseDescription: String // Описание
    var numberOfReps: Int16 // Количество повторений
    var successfulReps: Int16 // Количество успешных повторений
    var urlString: String // Ссылка на видео
    var localURLString: String? // Ссылка на сохранненное видео
    
}
