//
//  APIProtocol.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 09/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct PublicUserBuyerProfile: Codable {
    
    // MARK: - Properties
	var id: Int
	var isSmsVerificationRequired: Bool?
	var smsVerificationCode: String?
	var isSmsVerificationComplete: Bool?
	var isEmailVerificationRequired: Bool?
	var emailVerificationCode: String?
    var enquiryCount: Int?
    var viewingCount: Int?
    var offerCount: Int?
    var publicUserInterestTypes: Array<InterestTypes>?

	enum CodingKeys: String, CodingKey {
		case id
		case isSmsVerificationRequired = "is_sms_verification_required"
		case smsVerificationCode = "sms_verification_code"
		case isSmsVerificationComplete = "is_sms_verification_complete"
		case isEmailVerificationRequired = "is_email_verification_required"
		case emailVerificationCode = "email_verification_code"
        case enquiryCount = "enquiry_count"
        case viewingCount = "viewing_count"
        case offerCount = "offer_count"
        case publicUserInterestTypes = "public_user_interest_types"
	}

    // MARK: - Lifecycle
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(Int.self, forKey: .id)
		isSmsVerificationRequired = try values.decodeIfPresent(Bool.self, forKey: .isSmsVerificationRequired)
		smsVerificationCode = try values.decodeIfPresent(String.self, forKey: .smsVerificationCode)
		isSmsVerificationComplete = try values.decodeIfPresent(Bool.self, forKey: .isSmsVerificationComplete)
		isEmailVerificationRequired = try values.decodeIfPresent(Bool.self, forKey: .isEmailVerificationRequired)
		emailVerificationCode = try values.decodeIfPresent(String.self, forKey: .emailVerificationCode)
        enquiryCount = try values.decodeIfPresent(Int.self, forKey: .enquiryCount)
        viewingCount = try values.decodeIfPresent(Int.self, forKey: .viewingCount)
        offerCount = try values.decodeIfPresent(Int.self, forKey: .offerCount)
        publicUserInterestTypes = try values.decodeIfPresent(Array<InterestTypes>.self, forKey: .publicUserInterestTypes)
	}
}
