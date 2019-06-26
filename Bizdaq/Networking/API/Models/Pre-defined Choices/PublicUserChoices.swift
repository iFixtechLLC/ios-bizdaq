//
//  PublicUserChoices.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 24/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct PublicUserChoices: Codable {
    
    // MARK: - Properties
    typealias DecodedDictionary = [String: String]
    let howDidYouHearAboutUs: DecodedDictionary
    
    enum CodingKeys: String, CodingKey {
        case howDidYouHearAboutUs = "how_did_you_hear_about_us"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        howDidYouHearAboutUs = try values.decode(DecodedDictionary.self, forKey: .howDidYouHearAboutUs)
    }
}
