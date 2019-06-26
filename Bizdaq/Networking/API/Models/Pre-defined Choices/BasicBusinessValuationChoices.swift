//
//  BasicBusinessValuationChoices.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 18/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct BasicBusinessValuationChoices: Codable {
    
    // MARK: - Properties
    typealias DecodedDictionary = [String: String]
    let tenure: DecodedDictionary
    
    enum CodingKeys: String, CodingKey {
        case tenure
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        tenure = try values.decode(DecodedDictionary.self, forKey: .tenure)
    }
}
