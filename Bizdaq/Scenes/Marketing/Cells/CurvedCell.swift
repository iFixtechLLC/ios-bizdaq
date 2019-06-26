//
//  CurvedCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 23/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class CurvedCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    private let defaultConstraintValue: CGFloat = 0
    private let marginSize: CGFloat = 2
    static let cellHeight: CGFloat = 50
    
    enum State {
        case top
        case standard
        case bottom
        case standalone
    }
    private var state: State? {
        didSet {
            if let state = state { render(state: state) }
        }
    }
    
    // MARK: - Private Methods
    private func styleTableCellView(state: State, corners: UIRectCorner) {
        switch state {
        case .top:
            topConstraint.constant = marginSize
            bottomConstraint.constant = defaultConstraintValue
        case .standard:
            topConstraint.constant = defaultConstraintValue
            bottomConstraint.constant = defaultConstraintValue
        case .bottom:
            topConstraint.constant = defaultConstraintValue
            bottomConstraint.constant = marginSize
        case .standalone:
            topConstraint.constant = marginSize
            bottomConstraint.constant = marginSize
        }
        round(view: cellBackgroundView, corners: corners)
    }
    
    private func round(view: UIView, corners: UIRectCorner) {
        let applyMargins = corners.contains([.bottomLeft, .bottomRight])
        let path = UIBezierPath(roundedRect: CGRect(x: 0,
                                                    y: 0,
                                                    width: self.bounds.width,
                                                    height: self.bounds.height - (applyMargins ? marginSize : 0)),
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: 6.0, height: 6.0))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        view.layer.mask = shapeLayer
    }
    
    private func render(state: State) {
        switch state {
        case .top:
            styleTableCellView(state: state, corners: [.topLeft, .topRight])
        case .standard:
            styleTableCellView(state: state, corners: [])
        case .bottom:
            styleTableCellView(state: state, corners: [.bottomLeft, .bottomRight])
        case .standalone:
            styleTableCellView(state: state, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
        }
    }
    
    // MARK: - Public Methods
    func setState(_ state: State) {
        self.state = state
    }
}
