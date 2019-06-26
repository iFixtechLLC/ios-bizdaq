//
//  CreateBusinessEngagementViewingTests.swift
//  BizdaqTests
//
//  Created by Joseph Lunn on 13/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import XCTest
import Alamofire
import RxSwift
@testable import Bizdaq

class CreateBusinessEngagementViewingTests: XCTestCase {
    
    // MARK: - Properties
    let bag = DisposeBag()
    let timeout = TimeInterval(5)
    var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        self.apiClient = APIClient(httpClient: MockHTTPClient(fixture: "createBusinessEngagementViewing"))
    }
    
    func testListBusinessEngagementViewingsModelSerialization() {
        if let mockClient = apiClient.httpClient as? MockHTTPClient { mockClient.fixture = "createBusinessEngagementViewing" }
        let expectation = XCTestExpectation(description: "createBusinessEngagementViewing model should properly serialize from APIClient.createBusinessEngagementViewing() response")
        apiClient.createBusinessEngagementViewing(authToken: "",
                                                  businessEngagementId: 0,
                                                  dateOption1: "",
                                                  timeStartOption1: "",
                                                  dateOption2: "",
                                                  timeStartOption2: "",
                                                  dateOption3: "",
                                                  timeStartOption3: "")
            .subscribe(onSuccess: { (response) in
                expectation.fulfill()
            }) { (error) in
                XCTAssert(false)
            }
            .disposed(by: bag)
        wait(for: [expectation], timeout: timeout)
    }
}
