//
//  GradientView.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 17/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    // MARK: - Outlets
    @IBInspectable var startColor: UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor: UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double = 1 { didSet { updateLocations() }}
    @IBInspectable var endLocation: Double = 0 { didSet { updateLocations() }}
    
    // MARK: - Properties
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLocations()
        updateColors()
    }
    
    // MARK: - Private Methods
    private func updateLocations() {
        gradientLayer.startPoint = CGPoint(x: 0, y: startLocation)
        gradientLayer.endPoint = CGPoint(x: 0, y: endLocation)
    }
    
    private func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}

