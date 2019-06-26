//
//  Document.swift
//  Bizdaq
//
//  Created by App Dev on 31/03/2019.
//  Copyright © 2019 Coherent Software. All rights reserved.
//

import Foundation

struct Document: Codable {
    
    // MARK: - Properties
    let id: Int?
    let type: String?
    let typeOther: String?
    //year is Int in list and string in create response
    //let year: String?
    let originalFilename: String?
    let pathToFile: String?
    let mimeType: String?
    let fileSize: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case type = "type"
        case typeOther = "type_other"
        //case year = "year"
        case originalFilename = "original_filename"
        case pathToFile = "path_to_file"
        case mimeType = "mime_type"
        case fileSize = "file_size"
    }
    
    // MARK: - Properties
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        typeOther = try values.decodeIfPresent(String.self, forKey: .typeOther)
        //year = try values.decodeIfPresent(String.self, forKey: .year)
        originalFilename = try values.decodeIfPresent(String.self, forKey: .originalFilename)
        pathToFile = try values.decodeIfPresent(String.self, forKey: .pathToFile)
        mimeType = try values.decodeIfPresent(String.self, forKey: .mimeType)
        fileSize = try values.decodeIfPresent(Int.self, forKey: .fileSize)
    }
}
