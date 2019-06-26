//
//  ToggleSavedBusinessResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 03/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct ToggleSavedBusinessResponse: Codable {
    
//    struct Data: Codable {
//
//        // MARK: - Properties
//        let publicUser: PublicUser
//
//        enum CodingKeys: String, CodingKey {
//            case publicUser = "PublicUser"
//        }
//
//        // MARK - Lifecycle
//        init(from decoder: Decoder) throws {
//            let values = try decoder.container(keyedBy: CodingKeys.self)
//            publicUser = try values.decode(PublicUser.self, forKey: .publicUser)
//        }
//    }
    
    // MARK: - Properties
    let success: Bool
    //let data: Data
    
    enum CodingKeys: String, CodingKey {
        case success
        //case data
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
        //data = try values.decode(Data.self, forKey: .data)
    }
}
