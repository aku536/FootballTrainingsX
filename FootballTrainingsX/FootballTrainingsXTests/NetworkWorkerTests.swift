//
//  NetworkWorkerTests.swift
//  FootballTrainingsXTests
//
//  Created by Кирилл Афонин on 10/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import XCTest
@testable import FootballTrainingsX

class NetworkWorkerTests: XCTestCase {
    
    var networkWorker: NetworkWorker!
    
    override func setUp() {
        super.setUp()
        networkWorker = NetworkWorker()
    }
    
    override func tearDown() {
        networkWorker = nil
        super.tearDown()
    }
    
    func testThatNetworkRequestGetsHTTPStatusCode200() {
        // arrange
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/footballtrainingsx.appspot.com/o/test.mp4?alt=media&token=49f2beee-42ab-4d0d-9e7c-089ff6e73b83")
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        
        // act
        networkWorker.downloadVideo(with: url!) { (data, response) in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        // assert
        XCTAssertEqual(statusCode, 200, "Пришел неправильный ответ на запрос")
    }
    
    func testThatNetworkRequestCanHandleWrongURL() {
        // arrange
        let wrongUrl = URL(string: "https://firebasestorage.googleapi.com/v0/b/footballtrainingsx.appspot.com/o/test.mp4?alt=media&token=49f2beee-42ab-4d0d-9e7c-089ff6e73b83")
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        
        // act
        networkWorker.downloadVideo(with: wrongUrl!) { (data, response) in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        // assert
        XCTAssertNotEqual(statusCode, 200, "Пришел неправильный ответ на запрос")
    }
}
