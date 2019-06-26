//
//  BusinessDetailedViewModelTests.swift
//  BizdaqTests
//
//  Created by Joseph Lunn on 30/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import XCTest
import RxSwift
@testable import Bizdaq

class BusinessDetailedViewModelTests: XCTestCase {
    
    // MARK: - Properties
    let bag = DisposeBag()
    let timeout = TimeInterval(5)
    var business: Business!
    
    override func setUp() {
        super.setUp()
        let mockAPIResponse = modelFromFixture(fixture: "listBusinessesResponse", responseType: ListBusinessesResponse.self)!
        business = mockAPIResponse.data.first!
    }
    
    func testModelConfiguration() {
        let apiClient = APIClient(httpClient: HTTPClient.shared)
        let favouritesManager = FavouritesManager(apiClient: apiClient)
        let viewModel = BusinessDetailedViewModel(apiClient: apiClient, business: business, favouritesManager: favouritesManager)
        XCTAssert(viewModel.accomodation == business.propertyHasAccomodation!)
        XCTAssert(viewModel.askingPrice == business.askingPrice!.toCurrency())
        XCTAssert(viewModel.distance == Lexicon.BusinessBrowse.noValuePlaceholder)
        XCTAssert(viewModel.name == business.name!)
        XCTAssert(viewModel.location == business.businessLocation!.name!)
        XCTAssertTrue(viewModel.turnover == "\(business.annualTurnover!.toCurrency()) turnover")
        XCTAssert(viewModel.added == Lexicon.BusinessBrowse.noValuePlaceholder)
        XCTAssert(viewModel.opportunity == business.opportunity!)
        XCTAssert(viewModel.propertyType == business.tenure!)
        XCTAssert(viewModel.accomodation == business.propertyHasAccomodation!)
        XCTAssert(viewModel.staff == business.hasStaff!)
        XCTAssert(viewModel.netProfit == business.netProfit!.toCurrency())
        XCTAssert(viewModel.propertyType == business.tenure!)
        XCTAssert(viewModel.yearsEstablished == "\(business.yearBusinessEstablished!)")
    }
    
    func testBusinessSets() {
        let apiClient = APIClient(httpClient: HTTPClient.shared)
        let favouritesManager = FavouritesManager(apiClient: apiClient)
        let viewModel = BusinessDetailedViewModel(apiClient: apiClient, business: business, favouritesManager: favouritesManager)
        XCTAssertTrue(viewModel.business.name == business.name)
    }
    
    private func modelFromFixture<T>(fixture resource: String, responseType: T.Type) -> T? where T : Decodable {
        if let path = Bundle.main.path(forResource: resource, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonDecoder = JSONDecoder()
                let response = try jsonDecoder.decode(T.self, from: data)
                return response
            } catch {
                return nil
            }
        }
        return nil
    }
}
