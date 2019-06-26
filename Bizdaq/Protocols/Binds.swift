//
//  Binds.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 04/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

protocol Binds {
    associatedtype ViewModel
    
    func bind(to viewModel: ViewModel)
}
