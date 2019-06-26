//
//  BusinessEngagementBid.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 12/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

import Foundation

struct BusinessEngagementBid: Codable {
    
    let id: Int?
    let businessEngagementId: Int?
    let business: Business?
    let buyerPublicUser: BuyerPublicUser?
    let dateTimeBidMade: String?
    let bidAmount: Int?
    let terms: String?
    let timescale: String?
    let isFundingInPlace: String?
    let isBidCancelled: String?
    let dateTimeBidCancelled: String?
    let isBidReviewed: Bool?
    let dateTimeBidReviewed: String?
    let outcome: String?
    let outcomeReason: String?
    let counterBidAmount: String?
    let dateTimeCounterBidAmount: String?
    let isCounterBidReviewed: Bool?
    let dateTimeCounterBidReviewed: String?
    let counterBidOutcome: String?
    let counterBidOutcomeReason: String?
    let counterBidSellerNotes: String?
    let counterBidBuyerNotes: String?
    let isCompleted: Bool?
    let dateTimeCompleted: String?
    let dateTimeLastReminderEmailSent: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case businessEngagementId = "business_engagement_id"
        case business = "Business"
        case buyerPublicUser = "BuyerPublicUser"
        case dateTimeBidMade = "date_time_bid_made"
        case bidAmount = "bid_amount"
        case terms = "terms"
        case timescale = "timescale"
        case isFundingInPlace = "is_funding_in_place"
        case isBidCancelled = "is_bid_cancelled"
        case dateTimeBidCancelled = "date_time_bid_cancelled"
        case isBidReviewed = "is_bid_reviewed"
        case dateTimeBidReviewed = "date_time_bid_reviewed"
        case outcome = "outcome"
        case outcomeReason = "outcome_reason"
        case counterBidAmount = "counter_bid_amount"
        case dateTimeCounterBidAmount = "date_time_counter_bid_amount"
        case isCounterBidReviewed = "is_counter_bid_reviewed"
        case dateTimeCounterBidReviewed = "date_time_counter_bid_reviewed"
        case counterBidOutcome = "counter_bid_outcome"
        case counterBidOutcomeReason = "counter_bid_outcome_reason"
        case counterBidSellerNotes = "counter_bid_seller_notes"
        case counterBidBuyerNotes = "counter_bid_buyer_notes"
        case isCompleted = "is_completed"
        case dateTimeCompleted = "date_time_completed"
        case dateTimeLastReminderEmailSent = "date_time_last_reminder_email_sent"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        businessEngagementId = try values.decodeIfPresent(Int.self, forKey: .businessEngagementId)
        business = try values.decodeIfPresent(Business.self, forKey: .business)
        buyerPublicUser = try values.decodeIfPresent(BuyerPublicUser.self, forKey: .buyerPublicUser)
        dateTimeBidMade = try values.decodeIfPresent(String.self, forKey: .dateTimeBidMade)
        
        if let bidvalue = try? values.decodeIfPresent(Int.self, forKey: .bidAmount) {
            bidAmount = bidvalue
        } else {
            bidAmount = Int(try values.decodeIfPresent(String.self, forKey: .bidAmount) ?? "0")
        }
        
        
        
        terms = try values.decodeIfPresent(String.self, forKey: .terms)
        timescale = try values.decodeIfPresent(String.self, forKey: .timescale)
        isFundingInPlace = try values.decodeIfPresent(String.self, forKey: .isFundingInPlace)
        isBidCancelled = try values.decodeIfPresent(String.self, forKey: .isBidCancelled)
        dateTimeBidCancelled = try values.decodeIfPresent(String.self, forKey: .dateTimeBidCancelled)
        isBidReviewed = try values.decodeIfPresent(Bool.self, forKey: .isBidReviewed)
        dateTimeBidReviewed = try values.decodeIfPresent(String.self, forKey: .dateTimeBidReviewed)
        outcome = try values.decodeIfPresent(String.self, forKey: .outcome)
        outcomeReason = try values.decodeIfPresent(String.self, forKey: .outcomeReason)
        counterBidAmount = try values.decodeIfPresent(String.self, forKey: .counterBidAmount)
        dateTimeCounterBidAmount = try values.decodeIfPresent(String.self, forKey: .dateTimeCounterBidAmount)
        isCounterBidReviewed = try values.decodeIfPresent(Bool.self, forKey: .isCounterBidReviewed)
        dateTimeCounterBidReviewed = try values.decodeIfPresent(String.self, forKey: .dateTimeCounterBidReviewed)
        counterBidOutcome = try values.decodeIfPresent(String.self, forKey: .counterBidOutcome)
        counterBidOutcomeReason = try values.decodeIfPresent(String.self, forKey: .counterBidOutcome)
        counterBidSellerNotes = try values.decodeIfPresent(String.self, forKey: .counterBidSellerNotes)
        counterBidBuyerNotes = try values.decodeIfPresent(String.self, forKey: .counterBidBuyerNotes)
        isCompleted = try values.decodeIfPresent(Bool.self, forKey: .isCompleted)
        dateTimeCompleted = try values.decodeIfPresent(String.self, forKey: .dateTimeCompleted)
        dateTimeLastReminderEmailSent = try values.decodeIfPresent(String.self, forKey: .dateTimeLastReminderEmailSent)
    }
}
