//
//  MetricData.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 17/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct MetricData : Codable {
    
    // MARK: - Properties
    let net_profit : Int?
    let adjustments : Int?
    let asset_value : Int?
    let property : Int?
    
    enum CodingKeys: String, CodingKey {
        case net_profit = "net_profit"
        case adjustments = "adjustments"
        case asset_value = "asset_value"
        case property = "property"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        net_profit = try values.decodeIfPresent(Int.self, forKey: .net_profit)
        adjustments = try values.decodeIfPresent(Int.self, forKey: .adjustments)
        asset_value = try values.decodeIfPresent(Int.self, forKey: .asset_value)
        property = try values.decodeIfPresent(Int.self, forKey: .property)
    }
}
