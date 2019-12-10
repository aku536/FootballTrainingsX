//
//  FileManagerFake.swift
//  FootballTrainingsXTests
//
//  Created by Кирилл Афонин on 10/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import Foundation

class FileManagerStub: FileManager {
    
    var path: String?
    
    override func fileExists(atPath path: String) -> Bool {
        return path == self.path
    }
    override func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        return [URL(string: "https://firebasestorage.googleapis.com/v0/b/footballtrainingsx.appspot.com/o/test.mp4?alt=media&token=49f2beee-42ab-4d0d-9e7c-089ff6e73b83")!]
    }
    
    override func moveItem(at srcURL: URL, to dstURL: URL) throws {
        path = "/v0/b/footballtrainingsx.appspot.com/o/test.mp4/test.mp4"    
    }
    
    override func removeItem(atPath path: String) throws {
        self.path = nil
    }
}
