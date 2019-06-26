//
//  ListBusinessEngagementsResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 12/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct ListBusinessEngagementsResponse: Codable {
    
    struct Data: Codable {
        
        // MARK: - Properties
        let businessEngagements: [BusinessEngagement]?
        
        enum CodingKeys: String, CodingKey {
            case businessEngagements = "BusinessEngagements"
        }
        
        // MARK: - Lifecycle
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            businessEngagements = try values.decodeIfPresent([BusinessEngagement].self, forKey: .businessEngagements)
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
