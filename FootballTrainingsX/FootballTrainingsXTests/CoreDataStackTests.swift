//
//  CoreDataStackTests.swift
//  FootballTrainingsXTests
//
//  Created by Кирилл Афонин on 29/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import XCTest
@testable import FootballTrainingsX

class CoreDataStackTests: XCTestCase {
    
    var coreDataStack: CoreDataStack!

    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack.shared
    }

    override func tearDown() {
        coreDataStack = nil
       super.tearDown()
    }
    
    func testThatCoreDataStackIsASingletone() {
        // arrange
        let coreDataStack2 = CoreDataStack.shared
        
        // act
        let isEqual = coreDataStack === coreDataStack2
        
        // assert
        XCTAssertTrue(isEqual)
    }


}
