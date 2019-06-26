//
//  ListBusinessCategoriesTests.swift
//  BizdaqTests
//
//  Created by Joseph Lunn on 25/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import XCTest
import Alamofire
import RxSwift
@testable import Bizdaq

class ListBusinessCategoriesTests: XCTestCase {
    
    // MARK: - Properties
    let bag = DisposeBag()
    let timeout = TimeInterval(5)
    var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        self.apiClient = APIClient(httpClient: MockHTTPClient(fixture: "listBusinessCategories"))
    }
    
    func testListBusinessCategoriesModelSerialization() {
        if let mockClient = apiClient.httpClient as? MockHTTPClient { mockClient.fixture = "listBusinessCategories" }
        let expectation = XCTestExpectation(description: "listBusinessCategories model should properly serialize from APIClient.listBusinessCategories() response")
        apiClient.listBusinessCategories()
            .subscribe(onSuccess: { (response) in
                expectation.fulfill()
            }) { (error) in
                XCTAssert(false)
            }
            .disposed(by: bag)
        wait(for: [expectation], timeout: timeout)
    }
}
