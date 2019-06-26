//
//  RegisterSellerResponse.swift
//  Bizdaq
//
//  Created by App Dev on 08/04/2019.
//  Copyright © 2019 Coherent Software. All rights reserved.
//


import Foundation

struct RegisterSellerResponse: Codable {
    
    struct Data: Codable {
        
        // MARK: - Properties
        let user: User
        let business: Business
        
        enum CodingKeys: String, CodingKey {
            case user = "User"
            case business = "Business"
        }
        
        // MARK - Lifecycle
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            user = try values.decode(User.self, forKey: .user)
            business = try values.decode(Business.self, forKey: .business)

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


