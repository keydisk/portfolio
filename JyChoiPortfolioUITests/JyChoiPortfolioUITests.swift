//
//  JyChoiPortfolioUITests.swift
//  JyChoiPortfolioUITests
//
//  Created by JuYoung choi on 3/6/24.
//

import XCTest
@testable import JyChoiPortfolio

final class JyChoiPortfolioUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        
//        staticText.tap()
//        XCTAssert(element.element.frame.origin.y == 0)
    }
    
    func testScroll() throws {
        // UI tests must launch the application that they test.
        
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
