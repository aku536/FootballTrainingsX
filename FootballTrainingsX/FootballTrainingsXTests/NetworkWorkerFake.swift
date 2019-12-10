//
//  NetworkWorkerFake.swift
//  FootballTrainingsXTests
//
//  Created by Кирилл Афонин on 10/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import Foundation

class NetworkWorkerFake: NetworkWorker {
    override func downloadVideo(with url: URL, completion: @escaping (URL?, URLResponse?) -> Void) {
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/footballtrainingsx.appspot.com/o/test.mp4?alt=media&token=49f2beee-42ab-4d0d-9e7c-089ff6e73b83")
        let response = URLResponse(url: url!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        completion(url, response)
    }
}
