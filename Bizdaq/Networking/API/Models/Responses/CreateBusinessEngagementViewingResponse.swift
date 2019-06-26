//
//  CreateBusinessEngagementViewingResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 13/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct CreateBusinessEngagementViewingResponse: Codable {
    
    struct Data: Codable {
        
        // MARK: - Properties
        let businessEngagementViewing: BusinessEngagementViewing?
        
        enum CodingKeys: String, CodingKey {
            case businessEngagementViewing = "BusinessEngagementViewing"
        }
        
        // MARK: - Lifecycle
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            businessEngagementViewing = try values.decodeIfPresent(BusinessEngagementViewing.self, forKey: .businessEngagementViewing)
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
