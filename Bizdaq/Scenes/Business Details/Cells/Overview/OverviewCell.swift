//
//  OverviewCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 18/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class OverviewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var overviewLabel: UILabel!
    
    // MARK: - Public Methods
    func configure(with business: Business) {
        overviewLabel.text = business.opportunity ?? Lexicon.BusinessDetail.noValue
    }
}
