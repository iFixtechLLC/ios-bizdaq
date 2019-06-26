//
//  String+.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 06/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

extension String {
    
    static let empty = ""
    
    func matches(predicate: String) -> Bool {
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", predicate)
        return emailPredicate.evaluate(with: self)
    }
    
    func timestampToDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self)
    }
}
