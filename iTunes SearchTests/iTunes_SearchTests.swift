//
//  iTunes_SearchTests.swift
//  iTunes SearchTests
//
//  Created by Joseph Rogers on 4/20/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest
@testable import iTunes_Search
/*
 
 Does decoding work?
 Does decoding fail when given bad data?
 Does it build the correct URL?
 Does it build the correct URLRequest?
 are the search results saved properly?
 Is the completion handler called when data is good?
 Is the completion handler called when data is bad?
 Is the completion handler called when the network fails?
 
 
 create expectation
 create controller
 schedule work
 then wait
 
 */

class iTunes_SearchTests: XCTestCase {
    //runs perform search method
    
    func testForSomeResults() {
        
        //creating a expectation
        let expectation = self.expectation(description: "Wait for results")
        //creating a controller to work with within the test.
        let controller = SearchResultController()
        
        controller.performSearch(for: "GarageBand", resultType: .software) {
            print("Returned Results ⚠️")
            XCTAssertGreaterThan(controller.searchResults.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    //how to see how long the network took to get back to us 👇
    
    func testSpeedOfNetworkRequest() {
        measure {
            let expectation = self.expectation(description: "Wait for results")
            let controller = SearchResultController(dataLoader: URLSession(configuration: .ephemeral))
            controller.performSearch(for: "GarageBand", resultType: .software) {
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 5)
        }
    }
    
    //Detailed measurement - the shared URL is caching data in the policy so keep that in mind.
    func testSpeedOfAccurateNetworkRequest() {
        
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
        let mockDataLoader = MockDataLoader(data: goodResultData, response: nil, error: nil)
        
        let expectation = self.expectation(description: "Wait for results")
        let controller = SearchResultController(dataLoader: mockDataLoader)
        controller.performSearch(for: "GarageBand", resultType: .software) {
            //json has two results, this lets us know if this works fine
            
            XCTAssertEqual(controller.searchResults.count, 2, "expected 2 results for \"GarageBand\"⚠️")
            
            let firstResult = controller.searchResults[0]
            
            XCTAssertEqual(firstResult.title, "GarageBand")
            XCTAssertEqual(firstResult.artist, "Apple")
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testInValidJSON() {
        let mockDataLoader = MockDataLoader(data: badResultData, response: nil, error: nil)
        
        let expectation = self.expectation(description: "Wait for results")
        let controller = SearchResultController(dataLoader: mockDataLoader)
        controller.performSearch(for: "GarageBand", resultType: .software) {
            XCTAssertEqual(controller.searchResults.count, 0, "expected 0 results for \"GarageBand\"⚠️")
            XCTAssertTrue(controller.searchResults.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testNoResultsData() {
        let mockDataLoader = MockDataLoader(data: noResultsData, response: nil, error: nil)
        
        let expectation = self.expectation(description: "Wait for results")
        let controller = SearchResultController(dataLoader: mockDataLoader)
        controller.performSearch(for: "af;woeifawoef", resultType: .software) {
            XCTAssertEqual(controller.searchResults.count, 0, "expected 2 results for \"af;woeifawoef\"⚠️")
            XCTAssertTrue(controller.searchResults.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}


