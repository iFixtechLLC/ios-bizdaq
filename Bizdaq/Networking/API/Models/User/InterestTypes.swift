//
//  InterestTypes.swift
//  Bizdaq
//
//  Created by App Dev on 01/03/2019.
//  Copyright © 2019 Dreamr. All rights reserved.
//

import Foundation

struct InterestTypes: Codable {
    
    // MARK: - Properties
    var id: Int
    var businessSectorId: Int?
    var businessSectorName: String?
    var businessRegionId: Int?
    var businessRegionName: String?
    var created: String?
    
    struct Interest_types{
        var interest_type_sector_id:Int
        var interest_type_region_id:Int
    }
    enum DecodingKeys: String, CodingKey {
        case id
        case businessSectorId = "business_sector_id"
        case businessRegionId = "business_region_id"
        case created
        
    }
    enum EncodingKeys: String, CodingKey {
        case businessSectorId = "interest_type_sector_id"
        case businessRegionId = "interest_type_region_id"
    }
    func getValuesToSend() -> Interest_types{
        return Interest_types(interest_type_sector_id: businessSectorId!, interest_type_region_id: businessRegionId!)
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DecodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        businessSectorId = try values.decode(Int.self, forKey: .businessSectorId)
        businessRegionId = try values.decode(Int.self, forKey: .businessRegionId)
        created = try values.decode(String.self, forKey: .created)
    }
    
    init(sector_id: Int?, region_id: Int? ) throws{
        id = (sector_id!*100)+region_id! 
        businessSectorId = sector_id
        businessSectorName = DynamicLexicon.Business.sectors?.first(where:  { $0.id == sector_id })?.name
        
        businessRegionId = region_id
        businessRegionName = DynamicLexicon.Business.regions?.first(where:  { $0.id == region_id })?.name
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(businessSectorId, forKey: .businessSectorId)
        try container.encode(businessRegionId, forKey: .businessRegionId)
    }
}
