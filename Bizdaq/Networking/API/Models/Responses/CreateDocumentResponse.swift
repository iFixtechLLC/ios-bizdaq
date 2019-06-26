//
//  CreateDocumentResponse.swift
//  Bizdaq
//
//  Created by App Dev on 31/03/2019.
//  Copyright © 2019 Coherent Software. All rights reserved.
//


import Foundation
struct CreateDocumentResponse: Codable {
    
    struct Data: Codable {
        
        // MARK: - Properties
        let businessDocument: Document?
        
        enum CodingKeys: String, CodingKey {
            case businessDocument = "BusinessDocument"
        }
        
        // MARK: - Lifecycle
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            businessDocument = try values.decodeIfPresent(Document.self, forKey: .businessDocument)
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
        debugPrint(values)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        data = try values.decodeIfPresent(Data.self, forKey: .data)
        
    }
}
