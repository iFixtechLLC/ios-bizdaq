//
//  Message.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 10/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct Message: Codable {
    
    // MARK: - Properties
    let id: Int?
    //    let fromPublicUserId: Int?
    let fromPublicUser: PublicUser?
    //    let toPublicUserId: Int?
    let toPublicUser: PublicUser?
    let businessEngagementId: Int?
    let isActioned: Bool?
    let isActionApproved: Bool?
    let isActionDenied: Bool?
    let content: String?
    let timestamp: String?
    let type: String?
    let isRead: Bool?
    let isForRequestAccess: Bool?
    let actionRequired: Int?
    let buyerPublicUserId: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        //case fromPublicUserId = "from_public_user_id"
        //case toPublicUserId = "to_public_user_id"
        case fromPublicUser = "FromPublicUser"
        case toPublicUser = "ToPublicUser"
        case businessEngagementId = "business_engagement_id"
        case isActioned = "is_actioned"
        case isActionApproved = "is_action_approved"
        case isActionDenied = "is_action_denied"
        case isRead = "is_read"
        case isForRequestAccess = "is_for_request_access"
        case content
        case type // anything other than message?
        case timestamp
        case actionRequired = "action_required_by_public_user_id"
        case buyerPublicUserId = "buyer_public_user_id"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        fromPublicUser = try values.decodeIfPresent(PublicUser.self, forKey: .fromPublicUser)
        toPublicUser = try values.decodeIfPresent(PublicUser.self, forKey: .toPublicUser)
        businessEngagementId = try values.decodeIfPresent(Int.self, forKey: .businessEngagementId)
        isActioned = try values.decodeIfPresent(Bool.self, forKey: .isActioned)
        isActionApproved = try values.decodeIfPresent(Bool.self, forKey: .isActionApproved)
        isActionDenied = try values.decodeIfPresent(Bool.self, forKey: .isActionDenied)
        isRead = try values.decodeIfPresent(Bool.self, forKey: .isRead)
        isForRequestAccess = try values.decodeIfPresent(Bool.self, forKey: .isForRequestAccess)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        actionRequired = try values.decodeIfPresent(Int.self, forKey: .actionRequired)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp)
        buyerPublicUserId = try values.decodeIfPresent(Int.self, forKey: .buyerPublicUserId)
    }
    
    //SNEAKY METHOD FOR ACCESS THROUGH NON CONVERSATION
    //See viewmodel factory
    init(businessEngagmentId: Int, buyerId: Int) {
        businessEngagementId = businessEngagmentId
        id = nil
        fromPublicUser = nil
        toPublicUser = nil
        isActioned = nil
        isActionApproved = nil
        isActionDenied = nil
        isRead = nil
        isForRequestAccess = nil
        type = nil
        actionRequired = nil
        content = nil
        timestamp = nil
        buyerPublicUserId = buyerId
        
        
    }
    
}
