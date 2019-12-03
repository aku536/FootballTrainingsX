//
//  PercentageCalculator.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 03/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import Foundation

class PercentageCalculator {
    static func calculatePercenatge(count: String, total: String) -> String {
        if let count = Double(count),
            let total = Double(total),
            count > 0,
            total > 0 {
            return "\(Int(count/total*100))%"
        }
        else {
            return "0%"
        }
    }
}
