//
//  createBusinessEngagementResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 10/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct CreateBusinessEngagementResponse: Codable {
    
    struct Data: Codable {
        
        // MARK: - Properties
        let businessEngagement: BusinessEngagement?
        
        enum CodingKeys: String, CodingKey {
            case businessEngagement = "BusinessEngagement"
        }
        
        // MARK: - Lifecycle
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            businessEngagement = try values.decodeIfPresent(BusinessEngagement.self, forKey: .businessEngagement)
        }
    }
    
    // MARK: - Properties
    let success: Bool?
    let data: Data?
    
    enum CodingKeys: String, CodingKey {
        case success
        case data
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        data = try values.decodeIfPresent(Data.self, forKey: .data)
    }
}
