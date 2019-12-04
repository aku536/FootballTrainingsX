//
//  PercentageCalculator.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 03/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import Foundation

class PercentageCalculator {
    ///
    ///
    /// - Parameters:
    ///   - count: Количество успешно выполненных упражнений
    ///   - total: Общее количество подходов
    /// - Returns: Процент успешности в виде строки
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
