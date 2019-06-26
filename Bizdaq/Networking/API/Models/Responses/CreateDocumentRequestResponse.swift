//
//  CreateDocumentRequestResponse.swift
//  Bizdaq
//
//  Created by App Dev on 12/04/2019.
//  Copyright © 2019 Coherent Software. All rights reserved.
//

import Foundation
struct CreateDocumentRequestResponse: Codable {
    
    struct Data: Codable {
        
        // MARK: - Properties
        let businessEngagementDocumentRequest: BusinessEngagementDocumentRequest?
        
        enum CodingKeys: String, CodingKey {
            case businessEngagementDocumentRequest = "BusinessEngagementDocumentRequest"
        }
        
        // MARK: - Lifecycle
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            businessEngagementDocumentRequest = try values.decodeIfPresent(BusinessEngagementDocumentRequest.self, forKey: .businessEngagementDocumentRequest)
        }
    }
    
    // MARK: - Properties
    let success: Bool?
    let data: Data?
    
    enum CodingKeys: String, CodingKey {
        case success
        case data
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        data = try values.decodeIfPresent(Data.self, forKey: .data)
    }
}
