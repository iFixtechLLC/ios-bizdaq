//
//  BusinessEngagementBidChoices.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 18/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct BusinessEngagementBidChoices: Codable {
    
    // MARK: - Properties
    typealias DecodedDictionary = [String: String]
    let timescale: DecodedDictionary
    
    enum CodingKeys: String, CodingKey {
        case timescale = "timescale"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        timescale = try values.decode(DecodedDictionary.self, forKey: .timescale)
    }
}
