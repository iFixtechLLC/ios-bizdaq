//
//  LoginTests.swift
//  BizdaqTests
//
//  Created by Joseph Lunn on 13/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import XCTest
import RxSwift
@testable import Bizdaq

class LoginTests: XCTestCase {
    
    // MARK: - Properties
    let bag = DisposeBag()
    let timeout = TimeInterval(5)
    var apiClient: APIProtocol!
    
    override func setUp() {
        super.setUp()
        self.apiClient = APIClient(httpClient: MockHTTPClient(fixture: "loginResponse"))
    }
    
    func testLoginModelSerialization() {
        let expectation = XCTestExpectation(description: "Login model should properly serialize from APIClient.login() response")
        apiClient.login(emailAddress: "test@email.com", password: "fakePassword")
            .subscribe(onSuccess: { (response) in
                expectation.fulfill()
            }) { (error) in
                XCTAssert(false)
            }
            .disposed(by: bag)
        wait(for: [expectation], timeout: timeout)
    }
}
