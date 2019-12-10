//
//  TabBarCoordinatorTests.swift
//  FootballTrainingsXTests
//
//  Created by Кирилл Афонин on 11/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import XCTest
@testable import FootballTrainingsX

class TabBarCoordinatorTests: XCTestCase {
    
    var coordinator: TabBarCoordinator!
    var tabBarController: UITabBarController!
    var statsVC: UIViewController!

    override func setUp() {
        super.setUp()
        tabBarController = UITabBarController()
        statsVC = UIViewController()
        coordinator = TabBarCoordinator(tabBarVC: tabBarController, viewController: statsVC)
    }

    override func tearDown() {
        coordinator = nil
        statsVC = nil
        tabBarController = nil
        super.tearDown()
    }

    func testThatCoordinatorSetupTabBarWithTwoVC() {
        // arrange
        
        // act
        coordinator.setup()
        
        // assert
        XCTAssertEqual(tabBarController.viewControllers?.count, 2, "TabBar настроен неправильно. Количество контроллеров не равно 2")
    }
    
    func testThatShowStatsVCFuncShowStatsVC() {
        // arrange
        coordinator.setup()
        
        // act
        coordinator.showStatsVC()
        let isStatsVC = tabBarController.selectedViewController === statsVC
        
        // assert
        XCTAssertTrue(isStatsVC, "Необходимый контроллер не вызван")
    }

}
