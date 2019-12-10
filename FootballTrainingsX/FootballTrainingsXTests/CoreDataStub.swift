//
//  CoreDataStub.swift
//  FootballTrainingsXTests
//
//  Created by Кирилл Афонин on 10/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import Foundation

class CoreDataStub: CoreDataProtocol {
    
    var savedExercises = [Exercise]()
    
    static let shared: CoreDataProtocol = {
        let shared = CoreDataStub()
        return shared
    }()
    
    func loadFromMemory() -> [Exercise] {
        return savedExercises
    }
    
    func save(_ exercise: Exercise) {
        savedExercises.append(exercise)
    }
    
    func firstLaunchSettings(userDefaults: UserDefaults) {
        savedExercises.removeAll()
    }
}
