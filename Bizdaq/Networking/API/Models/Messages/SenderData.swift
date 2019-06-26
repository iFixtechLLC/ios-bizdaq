//
//  SenderData.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 27/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct SenderData: Codable {
    
    // MARK: - Properties
    let username: String?
    let photo: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case photo = "photo"
    }
    
    // MARK: - Properties
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        photo = try values.decodeIfPresent(String.self, forKey: .photo)
    }
}

