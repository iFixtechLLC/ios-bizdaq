//
//  CategoryListViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 29/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

class CategoryListViewModel {
    
    // MARK: - Properties
    var categories = [BusinessCategory]()
    var selectionHandler: ((_ sector: BusinessSector) -> Void)?
    var selectedCategory: BusinessCategory?
    var simplePopBack: Bool? = true

    
    // MARK: - Lifecycle
    init(selectionHandler: @escaping (_ sector: BusinessSector) -> Void) {
        self.selectionHandler = selectionHandler
        if let categories = DynamicLexicon.Business.categories {
            self.categories = categories
        }
    }
    
    // MARK: - Public Methods
    func setCategory(index: Int) {
        guard index < categories.count && index >= 0 else { return }
        selectedCategory = categories[index]
    }
}
