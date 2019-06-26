//
//  BusinessEngagement.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 10/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct BusinessEngagement: Codable {
    
    // MARK: - Properties
    let id: Int?
    let business: Business?
    let buyerPublicUserId: Int?
    let isFullDetailsRequested: Bool?
    let dateTimeFullDetailsRequestReviewed: String?
    let dateTimeFullDetailsRequested: String?
    let isFullDetailsRequestReviewed: Bool?
    let isFullDetailsAccessible: Bool?
    let isFullDetailsWithdrawn: Bool?
    let dateTimeFullDetailsWithdrawn: DateTime?
    let isAccountsRequested: Bool?
    let isAccountsAccessible: Bool?
    let isLeaseRequested: Bool?
    let isLeaseAccessible: Bool?
    let isStaffDetailsRequested: Bool?
    let isStaffDetailsAccessible: Bool?
    let isMessagingEnabled: Bool?
    let isBiddingEnabled: Bool?
    let initialBusinessEngagementMessage: TopLevelMessage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case business = "Business"
        case buyerPublicUserId = "buyer_public_user_id"
        case isFullDetailsRequested = "is_full_details_requested"
        case dateTimeFullDetailsRequestReviewed = "date_time_full_details_request_reviewed"
        case dateTimeFullDetailsRequested = "date_time_full_details_requested"
        case isFullDetailsRequestReviewed = "is_full_details_request_reviewed"
        case isFullDetailsAccessible = "is_full_details_accessible"
        case isFullDetailsWithdrawn = "is_full_details_withdrawn"
        case dateTimeFullDetailsWithdrawn = "date_time_full_details_withdrawn"
        case isAccountsRequested = "is_accounts_requested"
        case isAccountsAccessible = "is_accounts_accessible"
        case isLeaseRequested = "is_lease_requested"
        case isLeaseAccessible = "is_lease_accessible"
        case isStaffDetailsRequested = "is_staff_details_requested"
        case isStaffDetailsAccessible = "is_staff_details_accessible"
        case isMessagingEnabled = "is_messaging_enabled"
        case isBiddingEnabled = "is_bidding_enabled"
        case initialBusinessEngagementMessage = "initial_business_engagement_message"
    }
    
    // MARK: - Properties
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        business = try values.decodeIfPresent(Business.self, forKey: .business)
        buyerPublicUserId = try values.decodeIfPresent(Int.self, forKey: .buyerPublicUserId)
        isFullDetailsRequested = try values.decodeIfPresent(Bool.self, forKey: .isFullDetailsRequested)
        dateTimeFullDetailsRequestReviewed = try values.decodeIfPresent(String.self, forKey: .dateTimeFullDetailsRequestReviewed)
        dateTimeFullDetailsRequested = try values.decodeIfPresent(String.self, forKey: .dateTimeFullDetailsRequested)
        isFullDetailsRequestReviewed = try values.decodeIfPresent(Bool.self, forKey: .isFullDetailsRequestReviewed)
        isFullDetailsAccessible = try values.decodeIfPresent(Bool.self, forKey: .isFullDetailsAccessible)
        isFullDetailsWithdrawn = try values.decodeIfPresent(Bool.self, forKey: .isFullDetailsWithdrawn)
        dateTimeFullDetailsWithdrawn = try values.decodeIfPresent(DateTime.self, forKey: .dateTimeFullDetailsWithdrawn)
        isAccountsRequested = try values.decodeIfPresent(Bool.self, forKey: .isAccountsRequested)
        isAccountsAccessible = try values.decodeIfPresent(Bool.self, forKey: .isAccountsAccessible)
        isLeaseRequested = try values.decodeIfPresent(Bool.self, forKey: .isLeaseRequested)
        isLeaseAccessible = try values.decodeIfPresent(Bool.self, forKey: .isLeaseAccessible)
        isStaffDetailsRequested = try values.decodeIfPresent(Bool.self, forKey: .isStaffDetailsRequested)
        isStaffDetailsAccessible = try values.decodeIfPresent(Bool.self, forKey: .isStaffDetailsAccessible)
        isMessagingEnabled = try values.decodeIfPresent(Bool.self, forKey: .isMessagingEnabled)
        isBiddingEnabled = try values.decodeIfPresent(Bool.self, forKey: .isBiddingEnabled)
        initialBusinessEngagementMessage = try values.decodeIfPresent(TopLevelMessage.self, forKey: .initialBusinessEngagementMessage)
    }
}
