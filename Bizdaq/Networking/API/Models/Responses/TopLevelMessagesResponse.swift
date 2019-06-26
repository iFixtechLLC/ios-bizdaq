//
//  TopLevelMessagesResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 27/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct TopLevelMessagesResponse: Codable {
    
    struct Data: Codable {
        
        // MARK: - Properties
        typealias TopLevelMessages = [Message]
        let topLevelMessages: TopLevelMessages?
        
        enum CodingKeys: String, CodingKey {
            case topLevelMessages = "TopLevelMessages"
        }
        
        // MARK: - Lifecycle
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            topLevelMessages = try values.decodeIfPresent(TopLevelMessages.self, forKey: .topLevelMessages)
        }
    }
    
    // MARK: - Properties
    let data: Data?
    var success: Bool?

    enum CodingKeys: String, CodingKey {
        case data
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(Data.self, forKey: .data)
        if(data != nil){
            success = true
        }else{
            success = false
        }
    }
}

