//
//  Pagination.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 03/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct Pagination: Codable {
    
    // MARK: - Properties
    let totalBusinessCount: Int
    let perPage: Int
    let pageCount: Int
    
    enum CodingKeys: String, CodingKey {
        case totalBusinessCount = "total_count"
        case perPage = "per_page"
        case pageCount = "page_count"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalBusinessCount = try values.decode(Int.self, forKey: .totalBusinessCount)
        perPage = try values.decode(Int.self, forKey: .perPage)
        pageCount = try values.decode(Int.self, forKey: .pageCount)
    }
}
