//
//  PublicUserProfile.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 09/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
struct PublicUserProfile: Codable {
    
    // MARK: - Properties
	var id: Int?
	var bio: String?
    var careerBackground: String?
    var location: String?
	var photoOriginalFilename: String?
	var photoPathToFile: String?
	var isPostContactOptedIn: Bool?
	var isSmsContactOptedIn: Bool?
	var isPhoneContactOptedIn: Bool?
	var isEmailContactOptedIn: Bool?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case bio = "bio"
        case careerBackground = "career_background"
        case location = "location"
		case photoOriginalFilename = "photo_original_filename"
		case photoPathToFile = "photo_path_to_file"
		case isPostContactOptedIn = "is_post_contact_opted_in"
		case isSmsContactOptedIn = "is_sms_contact_opted_in"
		case isPhoneContactOptedIn = "is_phone_contact_opted_in"
		case isEmailContactOptedIn = "is_email_contact_opted_in"
	}

    // MARK: - Lifecycle
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		bio = try values.decodeIfPresent(String.self, forKey: .bio)
        careerBackground = try values.decodeIfPresent(String.self, forKey: .careerBackground)
        location = try values.decodeIfPresent(String.self, forKey: .location)
		photoOriginalFilename = try values.decodeIfPresent(String.self, forKey: .photoOriginalFilename)
		photoPathToFile = try values.decodeIfPresent(String.self, forKey: .photoPathToFile)
		isPostContactOptedIn = try values.decodeIfPresent(Bool.self, forKey: .isPostContactOptedIn)
		isSmsContactOptedIn = try values.decodeIfPresent(Bool.self, forKey: .isSmsContactOptedIn)
		isPhoneContactOptedIn = try values.decodeIfPresent(Bool.self, forKey: .isPhoneContactOptedIn)
		isEmailContactOptedIn = try values.decodeIfPresent(Bool.self, forKey: .isEmailContactOptedIn)
	}
}
