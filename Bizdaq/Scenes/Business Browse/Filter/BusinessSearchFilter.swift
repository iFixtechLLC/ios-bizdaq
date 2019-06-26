//
//  BusinessSearchFilter.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 02/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct BusinessSearchFilter {

    // MARK: - Properties
    var sectorId: Int?
    var categoryId: Int?
    var locationId: Int?
    var tenure: String?
    var price: (min: Int, max: Int)?
}
