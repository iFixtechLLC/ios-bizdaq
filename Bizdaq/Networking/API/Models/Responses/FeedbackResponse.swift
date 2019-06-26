//
//  FeedbackResponse.swift
//  Bizdaq
//
//  Created by App Dev on 01/03/2019.
//  Copyright © 2019 Dreamr. All rights reserved.
//

import Foundation

struct FeedbackResponse: Codable {
    
    struct Data: Codable {
        
        // MARK: - Properties
        let feedback: String
        
        enum CodingKeys: String, CodingKey {
            case feedback = "feedback"
        }
        
        // MARK - Lifecycle
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            feedback = try values.decode(String.self, forKey: .feedback)
        }
    }
    
    // MARK: - Properties
    let success: Bool
    let data: Data
    
    enum CodingKeys: String, CodingKey {
        case success
        case data
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
        data = try values.decode(Data.self, forKey: .data)
    }
}
