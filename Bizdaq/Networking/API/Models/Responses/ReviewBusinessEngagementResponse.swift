//
//  ReviewBusinessEngagementResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 24/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct ReviewBusinessEngagementResponse: Codable {
    
    struct Data: Codable {
        
        // MARK: - Properties
        let businessEngagement : BusinessEngagement?
        
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
        case success = "success"
        case data = "data"
    }
    
    // MARK: - Properties
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        data = try values.decodeIfPresent(Data.self, forKey: .data)
    }
}
