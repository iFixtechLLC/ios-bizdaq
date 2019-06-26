//
//  PreDefinedChoicesResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 24/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct ListPreDefinedChoicesResponse: Codable {
    
    struct Data: Codable {
        
        // MARK: - Properties
        let publicUserChoices: PublicUserChoices
        let businessChoices: BusinessChoices
        let businessEngagementChoices: BusinessEngagementBidChoices
        let businessDocumentChoices: BusinessDocumentChoices
        let basicBusinessValuationChoices: BasicBusinessValuationChoices
        
        enum CodingKeys: String, CodingKey {
            case publicUserChoices = "PublicUser"
            case businessChoices = "Business"
            case businessEngagementChoices = "BusinessEngagementBid"
            case businessDocumentChoices = "BusinessDocument"
            case basicBusinessValuationChoices = "BasicBusinessValuation"
        }
        
        // MARK: - Lifecycle
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            publicUserChoices = try values.decode(PublicUserChoices.self, forKey: .publicUserChoices)
            businessChoices = try values.decode(BusinessChoices.self, forKey: .businessChoices)
            businessEngagementChoices = try values.decode(BusinessEngagementBidChoices.self, forKey: .businessEngagementChoices)
            businessDocumentChoices = try values.decode(BusinessDocumentChoices.self, forKey: .businessDocumentChoices)
            basicBusinessValuationChoices = try values.decode(BasicBusinessValuationChoices.self, forKey: .basicBusinessValuationChoices)
        }
    }
    
    // MARK: - Properties
    let success: Bool
    let data: Data
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
        data = try values.decode(Data.self, forKey: .data)
    }
}
