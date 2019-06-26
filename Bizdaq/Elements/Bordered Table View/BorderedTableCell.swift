//
//  StatisticTableCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 12/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class BorderedTableCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var borderLayerView: UIView!
    @IBOutlet weak var backgroundLayerView: UIView!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var lockImageView: UIImageView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    static let cellHeight: CGFloat = 53.0
    private let defaultConstraintValue: CGFloat = -0.5
    
    enum State {
        case top
        case standard
        case bottom
    }
    private var state: State?
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayerView.layoutIfNeeded()
        backgroundLayerView.layoutIfNeeded()
        style()
    }
    
    // MARK: - Styling
    private func style() {
        selectionStyle = .none
        if let state = state { render(state: state) }
    }
    
    // MARK: - Private Methods
    private func render(state: State) {
        switch state {
        case .top:
            styleTableCellView(state: state, corners: [.topLeft, .topRight])
        case .standard:
            styleTableCellView(state: state, corners: [])
        case .bottom:
            styleTableCellView(state: state, corners: [.bottomLeft, .bottomRight])
        }
    }
    
    private func styleTableCellView(state: State, corners: UIRectCorner) {
        switch state {
        case .top:
            topConstraint.constant = 0
            bottomConstraint.constant = defaultConstraintValue
        case .standard:
            topConstraint.constant = defaultConstraintValue
            bottomConstraint.constant = defaultConstraintValue
        case .bottom:
            topConstraint.constant = defaultConstraintValue
            bottomConstraint.constant = 0
        }
        round(view: borderLayerView, corners: corners)
        round(view: backgroundLayerView, corners: corners)
    }
    
    private func round(view: UIView, corners: UIRectCorner) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0,
                                                    y: 0,
                                                    width: view.bounds.width,
                                                    height: view.bounds.height),
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: 3.0, height: 3.0))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        view.layer.mask = shapeLayer
    }
    
    // MARK: - Public Methods
    func setState(_ state: State) {
        self.state = state
    }
    
    func setValueHidden(_ hidden: Bool) {
        valueLabel.isHidden = hidden
        lockImageView.isHidden = !hidden
    }
}
