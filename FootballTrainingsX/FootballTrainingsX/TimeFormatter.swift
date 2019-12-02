//
//  TimeFormatter.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 29/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import Foundation

class TimeFormatter {
    /// Принимает секунды (от AVPlayer) и возвращает строку формата mm:ss
    ///
    /// - Parameter seconds: длительности медиа в AVPlayer
    /// - Returns: строка времени формата mm:ss
    func transformTimeToString(seconds: Float64) -> String {
        let secondsText = String(format: "%02d", Int(seconds) % 60)
        let minutesText = String(format: "%02d", Int(seconds) / 60)
        return "\(minutesText):\(secondsText)"
    }
}


