//
//  UIView+Xibs.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 07/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

extension UIView {
    
    func xibSetup() {
        let view = loadFromNib()
        addSubview(view)
        stretch(view)
    }
    
    func loadFromNib<T: UIView>() -> T {
        let selfType = type(of: self)
        let bundle = Bundle(for: selfType)
        let nibName = String(describing: selfType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? T else {
            fatalError("Error loading nib with name \(nibName).")
        }
        
        return view
    }
    
    fileprivate func stretch(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
