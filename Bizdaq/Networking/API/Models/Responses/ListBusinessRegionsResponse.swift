//
//  ListBusinessRegionsResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 25/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct ListBusinessRegionsResponse: Codable {
    
    // MARK: - Properties
    let success: Bool?
    let data: [BusinessRegion]?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        data = try values.decodeIfPresent([BusinessRegion].self, forKey: .data)
    }
}
