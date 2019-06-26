//
//  TopLevelMessage.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 27/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct TopLevelMessage: Codable {
    
    // MARK: - Properties
    let senderData: SenderData?
    let message: Message?
    
    enum CodingKeys: String, CodingKey {
        case senderData = "SenderData"
        case message = "Message"
    }
    
    // MARK: - Properties
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        senderData = try values.decodeIfPresent(SenderData.self, forKey: .senderData)
        message = try values.decodeIfPresent(Message.self, forKey: .message)
    }
}
