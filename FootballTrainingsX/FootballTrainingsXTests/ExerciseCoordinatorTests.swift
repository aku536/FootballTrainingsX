//
//  ExerciseCoordinatorTests.swift
//  FootballTrainingsXTests
//
//  Created by Кирилл Афонин on 11/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import XCTest
@testable import FootballTrainingsX

class ExerciseCoordinatorTests: XCTestCase {
    
    var coordinator: ExerciseCoordinator!
    var exerciseListVC: ExerciseListViewControllerStub!
    var navigationController: UINavigationController!
    var viewController: UIViewController!

    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
        viewController = UIViewController()
        exerciseListVC = ExerciseListViewControllerStub()
        coordinator = ExerciseCoordinator(exerciseListVC: exerciseListVC, exerciseVC: viewController)
    }

    override func tearDown() {
        coordinator = nil
        exerciseListVC = nil
        navigationController = nil
        viewController = nil
        super.tearDown()
    }

    func testThatCoordinatorPresentExerciseVCOnCallback() {
        // arrange
        coordinator.navigationController = navigationController
        coordinator.start()
        
        // act
        exerciseListVC.onExerciseSelect?()
        let isKindOfClass = navigationController.topViewController === viewController
        
        // assert
        XCTAssertTrue(isKindOfClass, "Второй ViewController не был вызван")
    }

}
