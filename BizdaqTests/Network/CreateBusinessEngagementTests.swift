//
//  CreateBusinessEngagementTests.swift
//  BizdaqTests
//
//  Created by Joseph Lunn on 12/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import XCTest
import Alamofire
import RxSwift
@testable import Bizdaq

class CreateBusinessEngagementTests: XCTestCase {
    
    // MARK: - Properties
    let bag = DisposeBag()
    let timeout = TimeInterval(5)
    var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        self.apiClient = APIClient(httpClient: MockHTTPClient(fixture: "createBusinessEngagement"))
    }
    
    func testCreateBusinessEngagementModelSerialization() {
        if let mockClient = apiClient.httpClient as? MockHTTPClient { mockClient.fixture = "createBusinessEngagement" }
        let expectation = XCTestExpectation(description: "createBusinessEgagement model should properly serialize from APIClient.createBusinessEngagement() response")
        apiClient.createBusinessEngagement(authToken: "", businessId: "", message: "")
            .subscribe(onSuccess: { (response) in
                expectation.fulfill()
            }) { (error) in
                XCTAssert(false)
            }
            .disposed(by: bag)
        wait(for: [expectation], timeout: timeout)
    }
}
