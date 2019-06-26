//
//  ListBusinessEngagementViewingsResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 12/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct ListBusinessEngagementViewingsResponse: Codable {
    
    struct Data: Codable {
        
        // MARK: - Properties
        let businessEngagementViewings: [BusinessEngagementViewing]?
        
        enum CodingKeys: String, CodingKey {
            case businessEngagementViewings = "BusinessEngagementViewings"
        }
        
        // MARK: - Lifecycle
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            businessEngagementViewings = try values.decodeIfPresent([BusinessEngagementViewing].self, forKey: .businessEngagementViewings)
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
