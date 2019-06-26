//
//  BusinessEngagementViewing.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 12/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct BusinessEngagementViewing: Codable {
    
    // MARK: - Properties
    let id: Int?
    let businessEngagementId: Int?
    let dateTimeOption1: String?
    let dateTimeOption2: String?
    let dateTimeOption3: String?
    let isViewingDateTimeOptionsSubmitted: Bool?
    let dateTimeViewingDateTimeOptionsSubmitted: String?
    let isViewingDateTimeOptionsReviewed: Bool?
    let dateTimeViewingDateTimeOptionsReviewed: String?
    let isViewingDateTimeAgreed: Bool?
    let viewingDateTime: String?
    let viewingDateTimeOptionsReasonForRejection: String?
    let isCancelled: Bool?
    let cancelledByName: String?
    let business: Business?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case businessEngagementId = "business_engagement_id"
        case dateTimeOption1 = "date_time_option1"
        case dateTimeOption2 = "date_time_option2"
        case dateTimeOption3 = "date_time_option3"
        case isViewingDateTimeOptionsSubmitted = "is_viewing_date_time_options_submitted"
        case dateTimeViewingDateTimeOptionsSubmitted = "date_time_viewing_date_time_options_submitted"
        case isViewingDateTimeOptionsReviewed = "is_viewing_date_time_options_reviewed"
        case dateTimeViewingDateTimeOptionsReviewed = "date_time_viewing_date_time_options_reviewed"
        case isViewingDateTimeAgreed = "is_viewing_date_time_agreed"
        case viewingDateTime = "viewing_date_time"
        case viewingDateTimeOptionsReasonForRejection = "viewing_date_time_options_reason_for_rejection"
        case isCancelled = "is_cancelled"
        case cancelledByName = "cancelled_by_name"
        case business = "Business"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        businessEngagementId = try values.decodeIfPresent(Int.self, forKey: .businessEngagementId)
        dateTimeOption1 = try values.decodeIfPresent(String.self, forKey: .dateTimeOption1)
        dateTimeOption2 = try values.decodeIfPresent(String.self, forKey: .dateTimeOption2)
        dateTimeOption3 = try values.decodeIfPresent(String.self, forKey: .dateTimeOption3)
        isViewingDateTimeOptionsSubmitted = try values.decodeIfPresent(Bool.self, forKey: .isViewingDateTimeOptionsSubmitted)
        dateTimeViewingDateTimeOptionsSubmitted = try values.decodeIfPresent(String.self, forKey: .dateTimeViewingDateTimeOptionsSubmitted)
        isViewingDateTimeOptionsReviewed = try values.decodeIfPresent(Bool.self, forKey: .isViewingDateTimeOptionsReviewed)
        dateTimeViewingDateTimeOptionsReviewed = try values.decodeIfPresent(String.self, forKey: .dateTimeViewingDateTimeOptionsReviewed)
        isViewingDateTimeAgreed = try values.decodeIfPresent(Bool.self, forKey: .isViewingDateTimeAgreed)
        viewingDateTime = try values.decodeIfPresent(String.self, forKey: .viewingDateTime)
        viewingDateTimeOptionsReasonForRejection = try values.decodeIfPresent(String.self, forKey: .viewingDateTimeOptionsReasonForRejection)
        isCancelled = try values.decodeIfPresent(Bool.self, forKey: .isCancelled)
        cancelledByName = try values.decodeIfPresent(String.self, forKey: .cancelledByName)
        business = try values.decodeIfPresent(Business.self, forKey: .business)
    }
}
