//
//  NetworkWorker.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 06/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import Foundation

class NetworkWorker {
    /// Загружает видео по ссылке и сохраняет его на устройстве
    ///
    /// - Parameters:
    ///   - url: ссылка на видео
    ///   - completion: возвращает ссылку на локально сохраненное видео
    func downloadVideo(with url: URL, completion: @escaping (String?) -> Void) {
        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let localPath = documentsDirectoryURL.appendingPathComponent(url.lastPathComponent).path
        
        if !FileManager.default.fileExists(atPath: localPath) {
            URLSession.shared.downloadTask(with: url) { (location, response, error) -> Void in
                guard let location = location else {
                    completion(nil)
                    return
                }
                let destinationURL = documentsDirectoryURL.appendingPathComponent(response?.suggestedFilename ?? url.lastPathComponent)
                do {
                    try FileManager.default.moveItem(at: location, to: destinationURL)
                    completion(destinationURL.absoluteString)
                } catch {
                    print(error)
                }
                }.resume()
        } else {
            do {
                try FileManager.default.removeItem(atPath: localPath)
                completion(nil)
            } catch {
                print(error)
            }
        }

    }
}
