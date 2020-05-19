//
//  iTunes_SearchTests.swift
//  iTunes SearchTests
//
//  Created by Dimitri Bouniol Lambda on 5/18/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest
@testable import iTunes_Search

/*

Does decoding work?
Does decoding fail when given bad data?
Does it build the correct URL?
Does it build the correct URLRequest?
Are the search results saved properly?
Is the completion handler called when data is good?
Is the completion handler called when data is bad?
Is the completion handler called when networking fails?

*/

class iTunes_SearchTests: XCTestCase {

    func testForSomeResults() {
        let expectation = self.expectation(description: "Wait for results")
//        let expectation = XCTestExpectation(description: "") // These are identical
        
        let controller = SearchResultController()
        
        controller.performSearch(for: "GarageBand", resultType: .software) { // (searchResults) in
            print("🥰 We got back some results!")
            XCTAssertGreaterThan(controller.searchResults.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssertGreaterThan(controller.searchResults.count, 0)
    }
    
    func testSpeedOfTypicalRequest() {
        measure {
            let expectation = self.expectation(description: "Wait for results")
            
            let controller = SearchResultController(dataLoader: URLSession(configuration: .ephemeral))
            
            controller.performSearch(for: "GarageBand", resultType: .software) {
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5)
        }
    }
    
    func testSpeedOfTypicalRequestMoreAccurately() {
        measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            let expectation = self.expectation(description: "Wait for results")
            
            let controller = SearchResultController(dataLoader: URLSession(configuration: .ephemeral))
            
            startMeasuring()
            controller.performSearch(for: "GarageBand", resultType: .software) {
                self.stopMeasuring()
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5)
        }
    }
    
    func testValidData() {
        let mockDataLoader = MockDataLoader(data: .mockJSONData(with: "GoodData"), response: nil, error: nil)
        
        let expectation = self.expectation(description: "Wait for results")
        
        let controller = SearchResultController(dataLoader: mockDataLoader)
        
        controller.performSearch(for: "GarageBand", resultType: .software) {
            XCTAssertEqual(controller.searchResults.count, 2, "Expected 2 results for \"GarageBand\"")
            
            let firstResult = controller.searchResults[0]
            
            XCTAssertEqual(firstResult.title, "GarageBand")
            XCTAssertEqual(firstResult.artist, "Apple")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
    }
    
    func testInvalidData() {
        let mockDataLoader = MockDataLoader(data: .mockJSONData(with: "BadData"), response: nil, error: nil)
        
        let expectation = self.expectation(description: "Wait for results")
        
        let controller = SearchResultController(dataLoader: mockDataLoader)
        
        controller.performSearch(for: "GarageBand", resultType: .software) {
            XCTAssertEqual(controller.searchResults.count, 0, "Expected 0 results for \"GarageBand\"")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
    }
    
    func testLoadingBadDataAfterValidResults() {
        let goodMockDataLoader = MockDataLoader(data: .mockJSONData(with: "GoodData"), response: nil, error: nil)
        
        let goodExpectation = self.expectation(description: "Wait for good results")
        
        let controller = SearchResultController(dataLoader: goodMockDataLoader)
        
        controller.performSearch(for: "GarageBand", resultType: .software) {
            XCTAssertEqual(controller.searchResults.count, 2, "Expected 2 results for \"GarageBand\"")
            
            let firstResult = controller.searchResults[0]
            
            XCTAssertEqual(firstResult.title, "GarageBand")
            XCTAssertEqual(firstResult.artist, "Apple")
            
            goodExpectation.fulfill()
        }
        
        wait(for: [goodExpectation], timeout: 1)
        
        let badMockDataLoader = MockDataLoader(data: .mockJSONData(with: "BadData"), response: nil, error: nil)
        
        let badExpectation = self.expectation(description: "Wait for bad results")
        
        controller.dataLoader = badMockDataLoader
        
        controller.performSearch(for: "GarageBand", resultType: .software) {
            XCTAssertEqual(controller.searchResults.count, 0, "Expected 0 results for \"GarageBand\"")
            
            badExpectation.fulfill()
        }
        
        wait(for: [badExpectation], timeout: 1)
    }
    
    func testUnavailableNetwork() {
        let mockDataLoader = MockDataLoader(data: nil, response: nil, error: NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotConnectToHost, userInfo: nil))
        
        let expectation = self.expectation(description: "Wait for results")
        
        let controller = SearchResultController(dataLoader: mockDataLoader)
        
        controller.performSearch(for: "GarageBand", resultType: .software) {
            XCTAssertEqual(controller.searchResults.count, 0, "Expected 0 results for \"GarageBand\"")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testCorrectURLRequest() {
        let mockDataLoader = MockDataLoader(data: .mockJSONData(with: "GoodData"), response: nil, error: nil)
        
        let expectation = self.expectation(description: "Wait for results")
        
        let controller = SearchResultController(dataLoader: mockDataLoader)
        
        controller.performSearch(for: "GarageBand", resultType: .software) {
            
            XCTAssertEqual(mockDataLoader.request?.httpMethod, HTTPMethod.get.rawValue)
            XCTAssertEqual(mockDataLoader.request?.url, URL(string: "https://itunes.apple.com/search?term=GarageBand&entity=software")!)
            
            XCTAssertEqual(controller.searchResults.count, 2, "Expected 2 results for \"GarageBand\"")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }

}
