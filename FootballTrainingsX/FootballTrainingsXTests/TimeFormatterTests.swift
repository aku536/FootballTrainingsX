//
//  TimeFormatterTests.swift
//  FootballTrainingsXTests
//
//  Created by Кирилл Афонин on 29/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import XCTest
@testable import FootballTrainingsX

class TimeFormatterTests: XCTestCase {
    
    var timeFormatter: TimeFormatter!

    override func setUp() {
        super.setUp()
        timeFormatter = TimeFormatter()
    }

    override func tearDown() {
        timeFormatter = nil
        super.tearDown()
    }

    func testThatTimeFormatterCorrectlyTransformsTimeToString() {
        // arrange
        let seconds = Float64(100)
        
        // act
        let timeString = timeFormatter.transformTimeToString(seconds: seconds)
        
        // assert
        XCTAssertEqual("01:40", timeString, "Время отформатировано некорректно")
    }

}
