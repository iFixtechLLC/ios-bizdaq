//
//  UploadBusinessPhotosResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 05/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct UploadBusinessPhotosResponse: Codable {
    
   
    // MARK: - Properties
    struct Data: Codable {
        
        // MARK: - Properties
        let business: Business?

        enum CodingKeys: String, CodingKey {
            case business = "Business"
        }
        
        // MARK: - Lifecycle
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            business = try values.decodeIfPresent(Business.self, forKey: .business)
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
