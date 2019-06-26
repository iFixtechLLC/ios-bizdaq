//
//  ListMessagesByEngagementResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 09/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct ListMessagesByEngagementResponse: Codable {
    
    struct Data: Codable {
        
        // MARK: - Properties
        let messages: [Message]?
        
        enum CodingKeys: String, CodingKey {
            case messages = "Messages"
        }
        
        // MARK: - Lifecycle
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            messages = try values.decodeIfPresent([Message].self, forKey: .messages)
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
