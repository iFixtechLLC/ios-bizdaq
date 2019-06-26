//
//  ListBusinessesResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 23/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct ListBusinessesResponse: Codable {
    
    // MARK: - Properties
    let success: Bool
    let data: [Business]
    let pagination: Pagination
    
    enum CodingKeys: String, CodingKey {
        case success
        case data
        case pagination
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
        data = try values.decode([Business].self, forKey: .data)
        pagination = try values.decode(Pagination.self, forKey: .pagination)
    }
}
