//
//  OnboardingPageViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 04/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct OnboardingPageViewModel {
    
    // MARK: - Properties
    let pageIndex: Int
    
    // MARK: - Lifecycle
    init(index: Int) {
        self.pageIndex = index
    }
}
