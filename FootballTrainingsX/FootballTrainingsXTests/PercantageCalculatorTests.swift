//
//  PercantageCalculatorTests.swift
//  FootballTrainingsXTests
//
//  Created by Кирилл Афонин on 06/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import XCTest
@testable import FootballTrainingsX

class PercantageCalculatorTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testThatCalculationsAreCorrect() {
        // arrange
        let count = "7"
        let total = "10"
        
        // act
        let percantage = PercentageCalculator.calculatePercenatge(count: count, total: total)
        
        // assert
        XCTAssertEqual("70%", percantage, "Процент посчитан неправильно")
    }
    
    func testThatPercantageCalculatorCanHandleIncorrectArguments() {
        // arrange
        let incorrectCount = "cемь"
        let total = "10"
        
        // act
        let percantage = PercentageCalculator.calculatePercenatge(count: incorrectCount, total: total)
        
        // assert
        XCTAssertEqual("0%", percantage, "Процент посчитан неправильно")
    }

}
