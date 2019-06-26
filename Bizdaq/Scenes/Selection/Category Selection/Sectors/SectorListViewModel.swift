//
//  SectorListViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 29/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

class SectorListViewModel {
    
    // MARK: - Properties
    var sectors = [BusinessSector]()
    let selectionHandler: (_ sector: BusinessSector) -> Void
    var selectedIndex: Int?
    var simplePopBack: Bool? = true
    
    // MARK: - Lifecycle
    init(category: BusinessCategory, selectionHandler: @escaping (_ sector: BusinessSector) -> Void) {
        self.selectionHandler = selectionHandler
        if let sectors = DynamicLexicon.Business.sectors {
            self.sectors = sectors.filter { $0.businessCategory?.id == category.id }
        }
    }
    
    func setSelected(index: Int) {
        selectedIndex = index
    }
}
