//
//  ValuationResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 17/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

enum ValuationResult {
    case widgets(_ widgets: Widgets)
    case valuation(_ valuation: BasicBusinessValuation)
}

struct CreateBusinessValuationResponse: Codable {
    
    // MARK: - Properties
    struct Data: Codable {
        
        // MARK: - Properties
        let widgets: Widgets?
        let basicBusinessValuation: BasicBusinessValuation?
        let interestedPartiesCount: Int?

        enum CodingKeys: String, CodingKey {
            case widgets = "widgets"
            case basicBusinessValuation = "BasicBusinessValuation"
            case interestedPartiesCount = "interested_parties_count"

        }
        
        // MARK: - Lifecycle
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            widgets = try values.decodeIfPresent(Widgets.self, forKey: .widgets)
            basicBusinessValuation = try values.decodeIfPresent(BasicBusinessValuation.self, forKey: .basicBusinessValuation)
            interestedPartiesCount = try values.decodeIfPresent(Int.self, forKey: .interestedPartiesCount)

        }
    }
    
    let success: Bool?
    let data: Data?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        data = try values.decodeIfPresent(Data.self, forKey: .data)
    }
}
