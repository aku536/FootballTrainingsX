//
//  UserDefaultsStub.swift
//  FootballTrainingsXTests
//
//  Created by Кирилл Афонин on 11/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import Foundation

class UserDefaultsStub: UserDefaults {
    
    var isLaunchedBefore = false
    
    override func set(_ value: Bool, forKey defaultName: String) {
        isLaunchedBefore = value
    }
    
    override func bool(forKey defaultName: String) -> Bool {
        return isLaunchedBefore
    }
}
