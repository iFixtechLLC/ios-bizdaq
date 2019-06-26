//
//  Int+.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 27/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

extension Int {
    
    func toCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_UK")
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        if let string = formatter.string(from: self as NSNumber) {
            return string
        } else {
            return ""
        }
    }
    static func parse(from string: String) -> Int? {
        return Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
    
}
