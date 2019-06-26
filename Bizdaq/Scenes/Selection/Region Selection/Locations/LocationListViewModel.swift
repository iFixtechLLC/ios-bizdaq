//
//  LocationListViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 03/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

class LocationListViewModel {
    
    // MARK: - Properties
    var locations = [BusinessLocation]()
    let selectionHandler: (_ sector: BusinessLocation) -> Void
    var selectedIndex: Int?
    var simplePopBack: Bool? = true

    // MARK: - Lifecycle
    init(region: BusinessRegion, selectionHandler: @escaping (_ location: BusinessLocation) -> Void) {
        self.selectionHandler = selectionHandler
        if let locations = DynamicLexicon.Business.locations {
            self.locations = locations.filter { $0.businessRegion?.id == region.id }
        }
    }
    
    func setSelected(index: Int) {
        selectedIndex = index
    }
}
