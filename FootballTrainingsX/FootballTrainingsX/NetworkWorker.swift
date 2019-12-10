//
//  NetworkWorker.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 06/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import Foundation

class NetworkWorker {
    /// Загружает видео и возрвращает его url
    ///
    /// - Parameters:
    ///   - url: ссылка на видео
    ///   - completion: location ссылка на локально сохраненный объект
    ///   response ответ полученный по ссылке
    func downloadVideo(with url: URL, completion: @escaping (URL?, URLResponse?) -> Void) {
        URLSession.shared.downloadTask(with: url) { (location, response, error) -> Void in
            guard let location = location, let response = response else {
                completion(nil, nil)
                return
            }
            completion(location, response)
            }.resume()
    }
}
