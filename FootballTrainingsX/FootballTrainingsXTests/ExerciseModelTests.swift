//
//  ExerciseModelTests.swift
//  FootballTrainingsXTests
//
//  Created by Кирилл Афонин on 10/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import XCTest
@testable import FootballTrainingsX

class ExerciseModelTests: XCTestCase {
    
    var model: ExerciseModel!
    var coreDataStub: CoreDataProtocol!
    var networkFake: NetworkWorker!
    var fileManager: FileManagerStub!

    override func setUp() {
        super.setUp()
        coreDataStub = CoreDataStub.shared
        networkFake = NetworkWorkerFake()
        fileManager = FileManagerStub()
        model = ExerciseModel(stack: coreDataStub, networkWorker: networkFake, fileManager: fileManager)
    }

    override func tearDown() {
        coreDataStub.firstLaunchSettings(userDefaults: UserDefaultsStub())
        coreDataStub = nil
        fileManager = nil
        model = nil
        super.tearDown()
    }
    
    func testThatModelCanSaveData() {
        // arrange
        var exercise = Exercise(type: "ex1", exerciseDescription: "Some exercise", numberOfReps: 10, successfulReps: 10, urlString: "url", localURLString: nil)
        model.exercisesList.append(exercise)
        
        // act
        exercise.numberOfReps = 100
        model.save(exercise)
        
        // assert
        XCTAssertEqual(100, model.exercisesList[0].numberOfReps, "Данные не сохранились")
    }

    func testThatModelCanResetData() {
        // arrange
        let exercise = Exercise(type: "ex1", exerciseDescription: "Some exercise", numberOfReps: 10, successfulReps: 10, urlString: "url", localURLString: nil)
        model.exercisesList.append(exercise)
        
        //act
        model.resetStats()
        
        //assert
        XCTAssertEqual(model.exercisesList[0].numberOfReps, 0, "Количество выполненных упражнений не обнулилось")
        XCTAssertEqual(model.exercisesList[0].successfulReps, 0, "Количество успешно выполненных упражнений не обнулилось")
        XCTAssertNotEqual(model.exercisesList[0].numberOfReps, 10, "Количество выполненных упражнений не изменилось")
        XCTAssertNotEqual(model.exercisesList[0].successfulReps, 10, "Количество успешно выполненных упражнений не изменилось")
    }
    
    func testThatSavingToFileManagerReturnsLocalURL() {
        // arrange
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/footballtrainingsx.appspot.com/o/test.mp4?alt=media&token=49f2beee-42ab-4d0d-9e7c-089ff6e73b83")
        var localUrl: String?
        let promise = expectation(description: "Было возвращено значение")
        
        //act
        model.saveToFileManager(with: url!) { (localURLString) in
            localUrl = localURLString
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        //assert
        XCTAssertNotNil(localUrl, "Не был возвращён локальный адрес сохранённого объекта")
    }
    
    func testThatModelCanDeleteFileIfItAlreadyExists() {
        // arrange
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/footballtrainingsx.appspot.com/o/test.mp4?alt=media&token=49f2beee-42ab-4d0d-9e7c-089ff6e73b83")
        var localUrl: String?
        let promise = expectation(description: "Было возвращено значение")
        
        //act
        model.saveToFileManager(with: url!) { (localURLString) in
            localUrl = localURLString
        }
        model.saveToFileManager(with: url!) { (localURLString) in
            localUrl = localURLString
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        //assert
        XCTAssertNil(localUrl, "Файл не был удален")
    }

}
