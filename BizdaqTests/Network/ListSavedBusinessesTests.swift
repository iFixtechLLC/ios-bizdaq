//
//  ListSavedBusinessesTests.swift
//  BizdaqTests
//
//  Created by Joseph Lunn on 22/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import XCTest
import Alamofire
import RxSwift
@testable import Bizdaq

class ListSavedBusinessesTests: XCTestCase {
    
    // MARK: - Properties
    let bag = DisposeBag()
    let timeout = TimeInterval(5)
    var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        self.apiClient = APIClient(httpClient: MockHTTPClient(fixture: "listSavedBusinesses"))
    }
    
    func testListBusinessEngagementViewingsModelSerialization() {
        if let mockClient = apiClient.httpClient as? MockHTTPClient { mockClient.fixture = "listSavedBusinesses" }
        let expectation = XCTestExpectation(description: "listSavedBusinesses model should properly serialize from APIClient.listSavedBusinesses() response")
        apiClient.listSavedBusinesses(authToken: "", page: "", perPage: "")
            .subscribe(onSuccess: { (response) in
                expectation.fulfill()
            }) { (error) in
                XCTAssert(false)
            }
            .disposed(by: bag)
        wait(for: [expectation], timeout: timeout)
    }
}
