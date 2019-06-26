//
//  PromoEmails.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 23/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct PromoEmails: Codable {
    
    // MARK: - Properties
    let id: Int?
    let emailsSent: String?
    let dateTimeCreated: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case emailsSent = "emails_sent"
        case dateTimeCreated = "date_time_created"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        emailsSent = try values.decodeIfPresent(String.self, forKey: .emailsSent)
        dateTimeCreated = try values.decodeIfPresent(String.self, forKey: .dateTimeCreated)
    }
    
    init() {
        id = 0
        emailsSent = "10"
        dateTimeCreated = Date().toDateStringRepresentation()
    }
}
