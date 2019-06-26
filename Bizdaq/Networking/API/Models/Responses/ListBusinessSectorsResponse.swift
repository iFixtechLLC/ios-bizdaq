//
//  ListBusinessSectorsResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 24/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct ListBusinessSectorsResponse: Codable {
    
    // MARK: - Properties
    let success: Bool
    let data: [BusinessSector]
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
        data = try values.decode([BusinessSector].self, forKey: .data)
    }
}
