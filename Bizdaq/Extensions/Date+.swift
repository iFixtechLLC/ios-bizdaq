//
//  Date+.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 03/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

extension Date {
    
    func toDateStringRepresentation() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    func toTimeStringRepresentation() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
