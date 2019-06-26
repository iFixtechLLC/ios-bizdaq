//
//  RegisterTests.swift
//  BizdaqTests
//
//  Created by Joseph Lunn on 13/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import XCTest
import Alamofire
import RxSwift
@testable import Bizdaq

class RegisterTests: XCTestCase {
    
    // MARK: - Properties
    let bag = DisposeBag()
    let timeout = TimeInterval(5)
    var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        self.apiClient = APIClient(httpClient:  MockHTTPClient(fixture: "registerBuyerResponse"))
    }
    
    func testRegisterBuyerModelSerialization() {
        if let mockClient = apiClient.httpClient as? MockHTTPClient { mockClient.fixture = "registerBuyerResponse" }
        let expectation = XCTestExpectation(description: "RegisterBuyer model should properly serialize from APIClient.registerBuyer() response")
        apiClient.registerBuyer(firstName: "firstName",
                                lastName: "lastName",
                                mobilePhone: "07123456789",
                                emailAddress: "test@email.com",
                                password: "fakePassword",
                                howDidYouHearAboutUs: "Lorum ipsum",
                                businessSectorsOfInterest: ["Lorem", "Ipsum"])
            .subscribe(onSuccess: { (response) in
                expectation.fulfill()
            }) { (error) in
                XCTAssert(false)
            }
            .disposed(by: bag)
        wait(for: [expectation], timeout: timeout)
    }
    
    func testRegisterSellerModelSerialization() {
        if let mockClient = apiClient.httpClient as? MockHTTPClient { mockClient.fixture = "registerSellerResponse" }
        let expectation = XCTestExpectation(description: "RegisterSeller model should properly serialize from APIClient.registerSeller() response")
        apiClient.registerSeller(firstName: "firstName",
                                 lastName: "lastName",
                                 mobilePhone: "071231231",
                                 emailAddress: "test@email.com",
                                 password: "fakePassword")
            .subscribe(onSuccess: { (response) in
                expectation.fulfill()
            }) { (error) in
                XCTAssert(false)
            }
            .disposed(by: bag)
        wait(for: [expectation], timeout: timeout)
    }
}
