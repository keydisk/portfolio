//
//  JyChoiPortfolioTests.swift
//  JyChoiPortfolioTests
//
//  Created by JuYoung choi on 3/6/24.
//

import XCTest
import Combine
@testable import JyChoiPortfolio

final class JyChoiPortfolioTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    let mainViewModel = MainViewModel()
    
    func test키워드로지점검색() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        self.mainViewModel.searchText = "잠"
        assert(self.mainViewModel.list.count == 2)
        self.mainViewModel.searchText = ""
        assert(self.mainViewModel.list.count == 5)
    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
