//
//  UINavigationBar+.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 06/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    func style() {
        barStyle = .black
        isTranslucent = false
        barTintColor = UIColor(named: "bizdaq-blue")
        tintColor = UIColor.white
        let blankImage = UIImage()
        shadowImage = blankImage
        setBackgroundImage(blankImage, for: .default)
    }
}
