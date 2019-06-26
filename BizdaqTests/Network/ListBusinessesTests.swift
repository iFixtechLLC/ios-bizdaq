//
//  ListBusinessesTests.swift
//  BizdaqTests
//
//  Created by Joseph Lunn on 23/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import XCTest
import Alamofire
import RxSwift
@testable import Bizdaq

class ListBusinessesTests: XCTestCase {
    
    // MARK: - Properties
    let bag = DisposeBag()
    let timeout = TimeInterval(5)
    var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        self.apiClient = APIClient(httpClient: MockHTTPClient(fixture: "listBusinessesResponse"))
    }
    
    func testListBusinessesModelSerialization() {
        if let mockClient = apiClient.httpClient as? MockHTTPClient { mockClient.fixture = "listBusinessesResponse" }
        let expectation = XCTestExpectation(description: "ListBusinesses model should properly serialize from APIClient.registerSeller() response")
        apiClient.listBusinesses(authToken: "",
                                 sectorId: "",
                                 categoryId: "",
                                 locationId: "",
                                 tenure: "",
                                 askingPriceMin: "",
                                 askingPriceMax: "",
                                 page: "",
                                 perPage: "",
            showInactive: nil)
            .subscribe(onSuccess: { (response) in
                expectation.fulfill()
            }) { (error) in
                XCTAssert(false)
            }
            .disposed(by: bag)
        wait(for: [expectation], timeout: timeout)
    }
}
