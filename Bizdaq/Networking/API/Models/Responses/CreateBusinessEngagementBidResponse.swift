//
//  CreateBusinessEngagementBidResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 20/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct CreateBusinessEngagementBidResponse: Codable {
    
    struct Data: Codable {
        
        // MARK: - Properties
        let businessEngagementBid: BusinessEngagementBid?
        
        enum CodingKeys: String, CodingKey {
            case businessEngagementBid = "BusinessEngagementBid"
        }
        
        // MARK: - Lifecycle
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            businessEngagementBid = try values.decodeIfPresent(BusinessEngagementBid.self, forKey: .businessEngagementBid)
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
