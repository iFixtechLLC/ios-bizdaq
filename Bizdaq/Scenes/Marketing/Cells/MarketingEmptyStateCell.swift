//
//  MarketingEmptyStateCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 23/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class MarketingEmptyStateCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Lifecycle
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        style(rounded: true, radius: frame.height/2)
    }
}
