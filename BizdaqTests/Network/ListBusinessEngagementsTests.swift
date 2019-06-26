//
//  ListBusinessEngagementsTests.swift
//  BizdaqTests
//
//  Created by Joseph Lunn on 12/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import XCTest
import Alamofire
import RxSwift
@testable import Bizdaq

class ListBusinessEngagementTests: XCTestCase {
    
    // MARK: - Properties
    let bag = DisposeBag()
    let timeout = TimeInterval(5)
    var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        self.apiClient = APIClient(httpClient: MockHTTPClient(fixture: "listBusinessEngagements"))
    }
    
    func testListBusinessEngagementModelSerialization() {
        if let mockClient = apiClient.httpClient as? MockHTTPClient { mockClient.fixture = "listBusinessEngagements" }
        let expectation = XCTestExpectation(description: "listBusinessEngagements model should properly serialize from APIClient.listBusinessEngagements() response")
        apiClient.listBusinessEngagements(authToken: "",
                                          businessId: nil,
                                          buyerPublicUserId: nil,
                                          isFullDetailsAccessible: nil,
                                          isFullDetailsPending: nil,
                                          page: nil,
                                          perPage: nil)
            .subscribe(onSuccess: { (response) in
                expectation.fulfill()
            }) { (error) in
                XCTAssert(false)
            }
            .disposed(by: bag)
        wait(for: [expectation], timeout: timeout)
    }
}
