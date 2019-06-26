//
//  BusinessBrowseFilterViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 02/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BusinessBrowseFilterViewModel {
    
    // MARK - Properties
    private let bag = DisposeBag()
    
    var sectorId: Int?
    var tenure: String?
    var locationId: Int?
    var price: (min: Int, max: Int)?
    
    private var tenureOptions = DynamicLexicon.PreDefinedChoices.Business.tenure
    var tenureStrings: [String] { guard let options = tenureOptions?.values else { return [] }; return Array(options) }
    
    var filter: BusinessSearchFilter?
    
    let minSliderValue = 0
    let maxSliderValue = 1000000
    
    var selectedSectorName: String? {
        if let id = sectorId {
            return sectorForId(id)?.name
        } else {
            return nil
        }
    }
    
    var selectedLocationName: String? {
        if let id = locationId {
            return locationForId(id)?.name
        } else {
            return nil
        }
    }
    
    // MARK: - Lifecycle
    init(filter: BusinessSearchFilter?) {
        self.filter = filter
        sectorId = filter?.sectorId
        tenure = filter?.tenure
        locationId = filter?.locationId
        price = filter?.price
    }
    
    // MARK: - Private Methods
    private func sectorForId(_ id: Int) -> BusinessSector? {
        return DynamicLexicon.Business.sectors?.filter { $0.id == id }.first
    }
    
    private func locationForId(_ id: Int) -> BusinessLocation? {
        return DynamicLexicon.Business.locations?.filter { $0.id == id }.first
    }
    
    // MARK: - Public Methods
    func setSector(_ value: Int?) {
        sectorId = value
    }
    
    func setTenure(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in
            guard let value = value else { return }
            self?.tenure = value
        })
        .disposed(by: bag)
    }
    
    func setLocation(_ value: Int?) {
        locationId = value
    }
    
    func setPrice(minPrice: Int, maxPrice: Int) {
        price = (minPrice, maxPrice)
    }
    
    func pickerIndexForTenure() -> Int? {
        if tenure != nil { return tenureStrings.index(of: tenure!) ?? nil } else { return nil }
    }
    
    func createFilter() -> BusinessSearchFilter {
        guard var filter = filter else {
            return BusinessSearchFilter(sectorId: sectorId, categoryId: nil, locationId: locationId, tenure: tenure, price: price)
        }
        
        filter.sectorId = sectorId
        filter.tenure = tenure
        filter.locationId = locationId
        filter.price = price
        return filter
    }
}
