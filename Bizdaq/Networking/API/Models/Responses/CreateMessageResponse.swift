//
//  CreateMessageResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 10/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct CreateMessageResponse: Codable {
    
    struct Data: Codable {
        
        // MARK: - Properties
        let message: Message?
        
        enum CodingKeys: String, CodingKey {
            case message = "Message"
        }
        
        // MARK: - Lifecycle
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            message = try values.decodeIfPresent(Message.self, forKey: .message)
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
