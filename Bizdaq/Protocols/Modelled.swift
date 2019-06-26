//
//  Modelled.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 03/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

protocol Modelled {
    associatedtype ViewModel
    
    func attach(to viewModel: ViewModel)
}
