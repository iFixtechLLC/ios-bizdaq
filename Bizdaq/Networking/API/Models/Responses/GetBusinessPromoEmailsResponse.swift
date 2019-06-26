//
//  GetBusinessPromoEmailsResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 23/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct GetBusinessPromoEmailsResponse: Codable {
    
    // MARK: - Properties
    struct Data: Codable {
        
        // MARK: - Properties
        let promoEmails: [PromoEmails]?
        
        enum CodingKeys: String, CodingKey {
            case promoEmails = "PromoEmails"
        }
        
        // MARK: - Lifecycle
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            promoEmails = try values.decodeIfPresent([PromoEmails].self, forKey: .promoEmails)
        }
    }
    
    let success: Bool?
    let data: Data?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        data = try values.decodeIfPresent(Data.self, forKey: .data)
    }
}
