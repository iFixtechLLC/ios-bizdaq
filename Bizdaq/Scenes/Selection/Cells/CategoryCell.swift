//
//  CategoryCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 29/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundBorderView: UIView!
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        style()
    }
    
    // MARK: - Styling
    private func style() {
        backgroundBorderView.style(borderWidth: 1.0, borderColor: Theme.UIElements.defaultBorderColor, rounded: true)
        selectionStyle = .none
    }
}
