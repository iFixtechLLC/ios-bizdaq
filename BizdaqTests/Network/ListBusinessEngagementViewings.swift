//
//  ListBusinessEngagementViewings.swift
//  BizdaqTests
//
//  Created by Joseph Lunn on 12/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import XCTest
import Alamofire
import RxSwift
@testable import Bizdaq

class ListBusinessEngagementViewingsTests: XCTestCase {
    
    // MARK: - Properties
    let bag = DisposeBag()
    let timeout = TimeInterval(5)
    var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        self.apiClient = APIClient(httpClient: MockHTTPClient(fixture: "listBusinessEngagementViewings"))
    }
    
    func testListBusinessEngagementViewingsModelSerialization() {
        if let mockClient = apiClient.httpClient as? MockHTTPClient { mockClient.fixture = "listBusinessEngagementViewings" }
        let expectation = XCTestExpectation(description: "listBusinessEngagementViewings model should properly serialize from APIClient.listBusinessEngagementViewings() response")
        apiClient.listBusinessEngagementViewings(authToken: "", businessId: "", buyerPublicUserId: "")
            .subscribe(onSuccess: { (response) in
                expectation.fulfill()
            }) { (error) in
                XCTAssert(false)
            }
            .disposed(by: bag)
        wait(for: [expectation], timeout: timeout)
    }
}
