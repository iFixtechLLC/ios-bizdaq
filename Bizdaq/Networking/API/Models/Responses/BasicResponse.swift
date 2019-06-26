//
//  BasicResponse.swift
//  Bizdaq
//
//  Created by App Dev on 01/03/2019.
//  Copyright © 2019 Dreamr. All rights reserved.
//


import Foundation

struct BasicResponse: Codable {
    
    // MARK: - Properties
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case success
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
    }
}
