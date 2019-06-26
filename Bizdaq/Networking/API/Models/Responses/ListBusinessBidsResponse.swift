//
//  ListBusinessBidsResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 02/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct ListBusinessBidsResponse: Codable {
    
    // MARK: - Properties
    struct Data: Codable {
        
        // MARK: - Properties
        let businessEngagementBids: [BusinessEngagementBid]?
        
        enum CodingKeys: String, CodingKey {
            case businessEngagementBids = "BusinessEngagementBids"
        }
        
        // MARK: - Lifecycle
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            businessEngagementBids = try values.decodeIfPresent([BusinessEngagementBid].self, forKey: .businessEngagementBids)
        }
    }
    
    let pagination: Pagination?
    let success: Bool?
    let data: Data?
    
    enum CodingKeys: String, CodingKey {
        case pagination = "pagination"
        case success = "success"
        case data = "data"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pagination = try values.decodeIfPresent(Pagination.self, forKey: .pagination)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        data = try values.decodeIfPresent(Data.self, forKey: .data)
    }
}
