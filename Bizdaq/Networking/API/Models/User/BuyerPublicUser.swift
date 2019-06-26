//
//  BuyerPublicUser.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 03/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct BuyerPublicUser : Codable {
    
    let id: Int?
    let firstName: String?
    let lastName: String?
    let email: String?
    let mobilePhone : String?
    let howDidYouHearAboutUs : String?
    let publicUserBuyerProfile : PublicUserBuyerProfile?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case mobilePhone = "mobile_phone"
        case howDidYouHearAboutUs = "how_did_you_hear_about_us"
        case publicUserBuyerProfile = "PublicUserBuyerProfile"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        mobilePhone = try values.decodeIfPresent(String.self, forKey: .mobilePhone)
        howDidYouHearAboutUs = try values.decodeIfPresent(String.self, forKey: .howDidYouHearAboutUs)
        publicUserBuyerProfile = try values.decodeIfPresent(PublicUserBuyerProfile.self, forKey: .publicUserBuyerProfile)
    }
}

