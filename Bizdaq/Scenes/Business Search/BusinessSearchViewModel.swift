//
//  BusinessSearchViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 19/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BusinessSearchViewModel {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var sectorId: Int?
    private var locationId: Int?
    
    // MARK: - Public Methods
    func createFilter() -> BusinessSearchFilter {
        return BusinessSearchFilter(sectorId: sectorId ?? nil, categoryId: nil, locationId: locationId ?? nil, tenure: nil, price: nil)
    }
    
    // MARK: - Public Methods
    func setSector(_ value: Int?) {
        sectorId = value
    }
    
    func setLocation(_ value: Int?) {
        locationId = value
    }
}
