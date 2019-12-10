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
        coreDataStack = (CoreDataStack.shared as! CoreDataStack)
    }
    
    override func tearDown() {
        coreDataStack = nil
        super.tearDown()
    }
    
    func testThatCoreDataStackIsASingletone() {
        // arrange
        let coreDataStack2 = (CoreDataStack.shared as! CoreDataStack)
        
        // act
        let isEqual = coreDataStack === coreDataStack2
        
        // assert
        XCTAssertTrue(isEqual)
    }
    
    func testThatStackCanRecognizeTheFirstLaunchOfApp() {
        // arrange
        let userDefaultsStub = UserDefaultsStub()
        
        // act
        coreDataStack.firstLaunchSettings(userDefaults: userDefaultsStub)
        
        // assert
        XCTAssertTrue(userDefaultsStub.isLaunchedBefore, "Приложение не изменило статус на  'launchedBefore'")
    }
    
}
