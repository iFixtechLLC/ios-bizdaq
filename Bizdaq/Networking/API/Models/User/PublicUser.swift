//
//  PublicUser.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 09/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct PublicUser: Codable {
    
    // MARK: - Properties
	var id: Int
	var firstName: String
	var lastName: String
	var email: String
    var mobilePhone: String
	var publicUserProfile: PublicUserProfile?
	var publicUserBuyerProfile: PublicUserBuyerProfile?
	var publicUserSellerProfile: PublicUserSellerProfile?
    var howDidYouHearAboutUs: String?

	enum CodingKeys: String, CodingKey {
		case id
		case firstName = "first_name"
		case lastName = "last_name"
		case email
        case mobilePhone = "mobile_phone"
		case publicUserProfile = "PublicUserProfile"
		case publicUserBuyerProfile = "PublicUserBuyerProfile"
		case publicUserSellerProfile = "PublicUserSellerProfile"
        case howDidYouHearAboutUs = "how_did_you_hear_about_us"
    }

    // MARK: - Lifecycle
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(Int.self, forKey: .id)
		firstName = try values.decode(String.self, forKey: .firstName)
		lastName = try values.decode(String.self, forKey: .lastName)
		email = try values.decode(String.self, forKey: .email)
        mobilePhone = try values.decode(String.self, forKey: .mobilePhone)
		publicUserProfile = try values.decodeIfPresent(PublicUserProfile.self, forKey: .publicUserProfile)
		publicUserBuyerProfile = try values.decodeIfPresent(PublicUserBuyerProfile.self, forKey: .publicUserBuyerProfile)
		publicUserSellerProfile = try values.decodeIfPresent(PublicUserSellerProfile.self, forKey: .publicUserSellerProfile)
        howDidYouHearAboutUs = try values.decodeIfPresent(String.self, forKey: .howDidYouHearAboutUs)

	}
}
