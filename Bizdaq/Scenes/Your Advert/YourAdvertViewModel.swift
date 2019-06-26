//
//  YourAdvertViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 19/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

class YourAdvertViewModel {
    
    // MARK: - Properties
    var business: Business
    
    // MARK: - Lifecycle
    init(business: Business) {
        self.business = business
    }
}
