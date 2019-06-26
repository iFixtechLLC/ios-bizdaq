//
//  OptionCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 14/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class OptionCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet var animatedConstraints: [NSLayoutConstraint]!
    
    // MARK: - Properties
    private var handler: (() -> Void)?
    var indexPath: IndexPath?
    
    static let viewWidth: CGFloat = 153.0
    static let viewHeight: CGFloat = 110.0
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        style()
        contentView.frame = bounds;
    }
    
    // MARK: - Styling
    private func style() {
        containerView.style(rounded: true)
        containerView.addShadow(radius: 2.0, offset: CGSize(width: 0, height: 2))
        autoresizesSubviews = true
    }
    
    // MARK: - Public Methods
    func setHandler(_ handler: @escaping () -> Void) {
        self.handler = handler
    }
    
    // MARK: - Private Methods
    private func animatePress() {
        let movement: CGFloat = 3
        UIView.animate(withDuration: 0.1, animations: {
            self.animatedConstraints.forEach({ (constraint) in
                constraint.constant = constraint.constant + movement
                self.layoutIfNeeded()
            })
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                self.animatedConstraints.forEach({ (constraint) in
                    constraint.constant = constraint.constant - movement
                    self.layoutIfNeeded()
                })
            })
        }
    }
    
    // MARK: - Actions
    @IBAction func didPressButton(_ sender: UIButton) {
        animatePress()
        handler?()
    }
}
