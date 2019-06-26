//
//  ListBusinessRegionsTests.swift
//  BizdaqTests
//
//  Created by Joseph Lunn on 25/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import XCTest
import Alamofire
import RxSwift
@testable import Bizdaq

class ListBusinessRegionsTests: XCTestCase {
    
    // MARK: - Properties
    let bag = DisposeBag()
    let timeout = TimeInterval(5)
    var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        self.apiClient = APIClient(httpClient: MockHTTPClient(fixture: "listBusinessRegions"))
    }
    
    func testListBusinessRegionsModelSerialization() {
        if let mockClient = apiClient.httpClient as? MockHTTPClient { mockClient.fixture = "listBusinessRegions" }
        let expectation = XCTestExpectation(description: "listBusinessRegions model should properly serialize from APIClient.listBusinessRegions() response")
        apiClient.listBusinessRegions()
            .subscribe(onSuccess: { (response) in
                expectation.fulfill()
            }) { (error) in
                XCTAssert(false)
            }
            .disposed(by: bag)
        wait(for: [expectation], timeout: timeout)
    }
}
