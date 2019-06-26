//
//  RegionsListViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 03/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

class RegionsListViewModel {
    
    // MARK: - Properties
    var regions = [BusinessRegion]()
    var selectionHandler: ((_ sector: BusinessLocation) -> Void)?
    var regionSelectionHandler: ((_ region: BusinessRegion) -> Void)?
    var selectedRegion: BusinessRegion?
    var simplePopBack: Bool? = true

    init(regionSelectionHandler: @escaping (_ region: BusinessRegion) -> Void) {
        self.regionSelectionHandler = regionSelectionHandler
        if let regions = DynamicLexicon.Business.regions {
            self.regions = regions
        }
    }
    // MARK: - Lifecycle
    init(selectionHandler: @escaping (_ sector: BusinessLocation) -> Void) {
        self.selectionHandler = selectionHandler
        if let regions = DynamicLexicon.Business.regions {
            self.regions = regions
        }
    }
    
    // MARK: - Public Methods
    func setRegion(index: Int) {
        guard index < regions.count && index >= 0 else { return }
        selectedRegion = regions[index]
    }
}
