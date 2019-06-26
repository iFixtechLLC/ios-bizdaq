//
//  ListDocuments.swift
//  Bizdaq
//
//  Created by App Dev on 31/03/2019.
//  Copyright © 2019 Coherent Software. All rights reserved.
//

import Foundation
struct ListDocumentsResponse: Codable {
    
    struct Data: Codable {
        
        // MARK: - Properties
        let businessDocuments: [Document]?
        
        enum CodingKeys: String, CodingKey {
            case businessDocuments = "BusinessDocuments"
        }
        
        // MARK: - Lifecycle
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            businessDocuments = try values.decodeIfPresent([Document].self, forKey: .businessDocuments)
        }
    }
    
    // MARK: - Properties
    let success: Bool?
    let data: Data?
    let pagination: Pagination?

    enum CodingKeys: String, CodingKey {
        case success
        case data
        case pagination = "pagination"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        data = try values.decodeIfPresent(Data.self, forKey: .data)
        pagination = try values.decodeIfPresent(Pagination.self, forKey: .pagination)

    }
}
