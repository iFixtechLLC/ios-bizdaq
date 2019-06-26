//
//  UserResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 13/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct UserResponse: Codable {
    
    struct Data: Codable {
        
        // MARK: - Properties
        let user: User
        
        enum CodingKeys: String, CodingKey {
            case user = "User"
        }
        
        // MARK - Lifecycle
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            user = try values.decode(User.self, forKey: .user)
        }
    }
    
    // MARK: - Properties
    let success: Bool
    let data: Data
    
    enum CodingKeys: String, CodingKey {
        case success
        case data
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
        data = try values.decode(Data.self, forKey: .data)
    }
}

