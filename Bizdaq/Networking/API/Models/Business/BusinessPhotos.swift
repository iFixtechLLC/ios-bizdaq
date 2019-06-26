//
//  BusinessPhotos.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 23/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct BusinessPhoto: Codable {
    
    // MARK: - Properties
    let id: Int?
    let originalFilename: String?
    let pathToFile: String?
    let displayOrder: Int?
    let isPrimary: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case originalFilename = "original_filename"
        case pathToFile = "path_to_file"
        case displayOrder = "display_order"
        case isPrimary = "is_primary"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        originalFilename = try values.decodeIfPresent(String.self, forKey: .originalFilename)
        pathToFile = try values.decodeIfPresent(String.self, forKey: .pathToFile)
        displayOrder = try values.decodeIfPresent(Int.self, forKey: .displayOrder)
        isPrimary = try values.decodeIfPresent(Bool.self, forKey: .isPrimary)
    }
}
