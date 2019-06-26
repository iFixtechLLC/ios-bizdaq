//
//  UIView+.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 06/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

extension UIView {
    
    func style(borderWidth: CGFloat, borderColor: UIColor, rounded: Bool) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = rounded ? 3.0 : 0.0
    }
    
    func style(rounded: Bool) {
        layer.cornerRadius = rounded ? 3.0 : 0.0
    }
    
    func style(rounded: Bool, radius: CGFloat?) {
        layer.cornerRadius = rounded ? (radius ?? 0.0) : 0.0
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addShadow(radius: CGFloat, offset: CGSize) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowOpacity = 0.05
    }
}
