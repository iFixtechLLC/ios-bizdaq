//
//  BusinessDocument.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 18/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct BusinessDocumentChoices: Codable {
    
    // MARK: - Properties
    typealias DecodedDictionary = [String: String]
    let type: DecodedDictionary
    let year: DecodedDictionary
    
    enum CodingKeys: String, CodingKey {
        case type
        case year
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(DecodedDictionary.self, forKey: .type)
        year = try values.decode(DecodedDictionary.self, forKey: .year)
    }
}
