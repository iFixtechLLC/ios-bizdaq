//
//  ListPreDefinedChoicesTests.swift
//  BizdaqTests
//
//  Created by Joseph Lunn on 24/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import XCTest
import Alamofire
import RxSwift
@testable import Bizdaq

class ListPreDefinedChoicesTests: XCTestCase {
    
    // MARK: - Properties
    let bag = DisposeBag()
    let timeout = TimeInterval(5)
    var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        self.apiClient = APIClient(httpClient: MockHTTPClient(fixture: "listPreDefinedChoicesResponse"))
    }
    
    func testListPreDefinedChoicesModelSerialization() {
        if let mockClient = apiClient.httpClient as? MockHTTPClient { mockClient.fixture = "listPreDefinedChoicesResponse" }
        let expectation = XCTestExpectation(description: "listPreDefinedChoices model should properly serialize from APIClient.listPreDefinedChoices() response")
        apiClient.listPreDefinedChoices()
            .subscribe(onSuccess: { (response) in
                expectation.fulfill()
            }) { (error) in
                XCTAssert(false)
            }
            .disposed(by: bag)
        wait(for: [expectation], timeout: timeout)
    }
}
