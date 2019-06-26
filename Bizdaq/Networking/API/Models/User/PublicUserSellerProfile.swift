//
//  User.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 09/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct PublicUserSellerProfile: Codable {
    
    // MARK: - Properties
	var id: Int
    var enquiryCount: Int
    var viewsCount: Int
    var viewingCount: Int
    var offerCount: Int

	enum CodingKeys: String, CodingKey {
		case id
        case enquiryCount = "enquiry_count"
        case viewsCount = "views_count"
        case viewingCount = "viewing_count"
        case offerCount = "offer_count"
	}

    // MARK: - Lifecycle
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(Int.self, forKey: .id)
        enquiryCount = try values.decode(Int.self, forKey: .enquiryCount)
        viewsCount = try values.decode(Int.self, forKey: .viewsCount)
        viewingCount = try values.decode(Int.self, forKey: .viewingCount)
        offerCount = try values.decode(Int.self, forKey: .offerCount)
	}
}
