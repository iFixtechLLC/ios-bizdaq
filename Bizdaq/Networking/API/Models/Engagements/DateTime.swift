//
//  DateTime.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 07/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct DateTime : Codable {
    
    let date: String?
    let timezoneType: Int?
    let timezone: String?
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case timezoneType = "timezone_type"
        case timezone = "timezone"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        timezoneType = try values.decodeIfPresent(Int.self, forKey: .timezoneType)
        timezone = try values.decodeIfPresent(String.self, forKey: .timezone)
    }
}
