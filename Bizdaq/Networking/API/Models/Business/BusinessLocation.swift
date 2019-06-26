//
//  BusinessLocation.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 23/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct BusinessLocation: Codable {
    
    // MARK: - Properties
    let id: Int?
    let name: String?
    let businessRegion: BusinessRegion?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case businessRegion = "BusinessRegion"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        businessRegion = try values.decodeIfPresent(BusinessRegion.self, forKey: .businessRegion)
    }
}
