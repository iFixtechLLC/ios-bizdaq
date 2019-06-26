//
//  Address.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 23/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct BusinessAddress: Codable {
    
    // MARK: - Prcoperties
    let line1: String?
    let line2: String?
    let line3: String?
    let townCity: String?
    let postcode: String?
    
    enum CodingKeys: String, CodingKey {
        case line1 = "line1"
        case line2 = "line2"
        case line3 = "line3"
        case townCity = "town_city"
        case postcode = "postcode"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        line1 = try values.decodeIfPresent(String.self, forKey: .line1)
        line2 = try values.decodeIfPresent(String.self, forKey: .line2)
        line3 = try values.decodeIfPresent(String.self, forKey: .line3)
        townCity = try values.decodeIfPresent(String.self, forKey: .townCity)
        postcode = try values.decodeIfPresent(String.self, forKey: .postcode)
    }
}
