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
    
    var percentageCalculator: PercentageCalculator!

    override func setUp() {
        super.setUp()
        percentageCalculator = PercentageCalculator()
    }

    override func tearDown() {
        percentageCalculator = nil
        super.tearDown()
    }

    func testThatCalculatorComputesPercantageCorrectly() {
        // arrange
        let count = "7"
        let total = "10"
        
        // act
        let percentage = percentageCalculator.calculatePercenatge(count: count, total: total)
        
        // assert
        XCTAssertEqual("70%", percentage, "Процент посчитан неправильно")
    }
    
    func testThatPercantageCalculatorCanHandleIncorrectArguments() {
        // arrange
        let incorrectCount = "cемь"
        let total = "10"
        
        // act
        let percentage = percentageCalculator.calculatePercenatge(count: incorrectCount, total: total)
        
        // assert
        XCTAssertEqual("0%", percentage, "Процент посчитан неправильно")
    }

}
