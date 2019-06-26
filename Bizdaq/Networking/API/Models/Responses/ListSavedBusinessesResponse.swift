//
//  ListSavedBusinessesResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 22/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct ListSavedBusinessesResponse: Codable {
    
    // MARK: - Properties
    let success: Bool?
    let data: [Business]?
    let pagination: Pagination?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
        case pagination = "pagination"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        data = try values.decodeIfPresent([Business].self, forKey: .data)
        pagination = try values.decodeIfPresent(Pagination.self, forKey: .pagination)
    }
}
