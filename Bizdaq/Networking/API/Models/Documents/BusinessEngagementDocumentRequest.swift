//
//  Document.swift
//  Bizdaq
//
//  Created by App Dev on 31/03/2019.
//  Copyright © 2019 Coherent Software. All rights reserved.
//

import Foundation

struct BusinessEngagementDocumentRequest: Codable {
    
    // MARK: - Properties
    let id: Int?
    let businessEngagementId: Int?
    let type: String?
    let typeOther: String?
    //year is Int in list and string in create response
    //let year: String?

    let isRequestedReviewed: Bool?
    let isRequestApproved: Bool?
    let resultingBusinessDocumentId: Int?
    let isRequestRejected: Bool?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case type = "type"
        case typeOther = "type_other"
        //case year = "year"
        case businessEngagementId = "business_engagement_id"
        case isRequestedReviewed = "is_requested_reviewed"
        case isRequestApproved = "is_request_approved"
        case resultingBusinessDocumentId = "resulting_business_document_id"
        case isRequestRejected = "is_request_rejected"
    }
    
    // MARK: - Properties
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        typeOther = try values.decodeIfPresent(String.self, forKey: .typeOther)
        //year = try values.decodeIfPresent(String.self, forKey: .year)
        isRequestedReviewed = try values.decodeIfPresent(Bool.self, forKey: .isRequestedReviewed)
        isRequestApproved = try values.decodeIfPresent(Bool.self, forKey: .isRequestApproved)
        isRequestRejected = try values.decodeIfPresent(Bool.self, forKey: .isRequestRejected)
        businessEngagementId = try values.decodeIfPresent(Int.self, forKey: .businessEngagementId)
        resultingBusinessDocumentId = try values.decodeIfPresent(Int.self, forKey: .resultingBusinessDocumentId)

    }
}
