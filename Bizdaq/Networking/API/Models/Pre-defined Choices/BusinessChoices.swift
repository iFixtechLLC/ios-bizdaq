//
//  BusinessChoices.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 24/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct BusinessChoices: Codable {
    
    // MARK: - Properties
    typealias DecodedDictionary = [String: String]
    let tenure: DecodedDictionary
    let propertyHasAccomodation: DecodedDictionary
    let hasStaff: DecodedDictionary
    let currentStatus: DecodedDictionary
    
    enum CodingKeys: String, CodingKey {
        case tenure = "tenure"
        case propertyHasAccomodation = "property_has_accomodation"
        case hasStaff = "has_staff"
        case currentStatus = "current_status"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        tenure = try values.decode(DecodedDictionary.self, forKey: .tenure)
        propertyHasAccomodation = try values.decode(DecodedDictionary.self, forKey: .propertyHasAccomodation)
        hasStaff = try values.decode(DecodedDictionary.self, forKey: .hasStaff)
        currentStatus = try values.decode(DecodedDictionary.self, forKey: .currentStatus)
    }
}
