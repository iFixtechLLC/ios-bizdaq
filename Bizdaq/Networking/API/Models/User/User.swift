//
//  User.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 09/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct User: Codable {
    
    // MARK: - Properties
	let id: Int
	let token: String
	var publicUser: PublicUser

    enum CodingKeys: String, CodingKey {
		case id
		case token
		case publicUser = "PublicUser"
	}
    
    // MARK: - Lifecycle
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(Int.self, forKey: .id)
		token = try values.decode(String.self, forKey: .token)
		publicUser = try values.decode(PublicUser.self, forKey: .publicUser)
	}
}
