//
//  BasicBusinessValuation.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 17/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct BasicBusinessValuation: Codable {
    
    // MARK: - Properties
    let id: Int?
    let anonymousUserEmailAddress: String?
    let anonymousUserName: String?
    let anonymousUserPhoneNumber: String?
    let isSentByEmail: String?
    let businessSectorId: Int?
    let tenure: String?
    let annualTurnover: String?
    let businessPostcode: String?
    let propertyFreeholdValue: String?
    let metricData: MetricData?
    let estimatedValueLower: String?
    let estimatedValueUpper: String?
    let isSaved: String?
    let interestedPartiesCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case anonymousUserEmailAddress = "anonymous_user_email_address"
        case anonymousUserName = "anonymous_user_name"
        case anonymousUserPhoneNumber = "anonymous_user_phone_number"
        case isSentByEmail = "is_sent_by_email"
        case businessSectorId = "business_sector_id"
        case tenure = "tenure"
        case annualTurnover = "annual_turnover"
        case businessPostcode = "business_postcode"
        case propertyFreeholdValue = "property_freehold_value"
        case metricData = "metric_data"
        case estimatedValueLower = "estimated_value_lower"
        case estimatedValueUpper = "estimated_value_upper"
        case isSaved = "is_saved"
        case interestedPartiesCount = "interested_parties_count"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        anonymousUserEmailAddress = try values.decodeIfPresent(String.self, forKey: .anonymousUserEmailAddress)
        anonymousUserName = try values.decodeIfPresent(String.self, forKey: .anonymousUserName)
        anonymousUserPhoneNumber = try values.decodeIfPresent(String.self, forKey: .anonymousUserPhoneNumber)
        isSentByEmail = try values.decodeIfPresent(String.self, forKey: .isSentByEmail)
        businessSectorId = try values.decodeIfPresent(Int.self, forKey: .businessSectorId)
        tenure = try values.decodeIfPresent(String.self, forKey: .tenure)
        annualTurnover = try values.decodeIfPresent(String.self, forKey: .annualTurnover)
        businessPostcode = try values.decodeIfPresent(String.self, forKey: .businessPostcode)
        propertyFreeholdValue = try values.decodeIfPresent(String.self, forKey: .propertyFreeholdValue)
        metricData = try values.decodeIfPresent(MetricData.self, forKey: .metricData)
        estimatedValueLower = try values.decodeIfPresent(String.self, forKey: .estimatedValueLower)
        estimatedValueUpper = try values.decodeIfPresent(String.self, forKey: .estimatedValueUpper)
        isSaved = try values.decodeIfPresent(String.self, forKey: .isSaved)
        interestedPartiesCount = try values.decodeIfPresent(Int.self, forKey: .interestedPartiesCount)
    }
}
