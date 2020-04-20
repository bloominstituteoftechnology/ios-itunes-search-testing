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
        let controller = SearchResultController()
        
        controller.performSearch(for: "GarageBand", resultType: .software) {
            print("Returned Results ⚠️")
            XCTAssertGreaterThan(controller.searchResults.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }

}
