//
//  InformationCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 14/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class InformationCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tenureLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var turnoverLabel: UILabel!
    @IBOutlet weak var addedLabel: UILabel!
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        style()
    }
    
    // MARK: - Styling
    private func style() {
        selectionStyle = .none
    }
    
    // MARK: - Public Methods
    func configure(with business: Business) {
        priceLabel.text = "\(business.askingPrice?.toCurrency() ?? 0.toCurrency())"
        tenureLabel.text = business.tenure ?? Lexicon.BusinessDetail.noValue
        nameLabel.text = business.advertHeadline ?? Lexicon.BusinessDetail.noValue
        locationLabel.text = business.businessLocation?.businessRegion?.name ?? Lexicon.BusinessDetail.noValue
        turnoverLabel.text = "\(business.annualTurnover?.toCurrency() ?? 0.toCurrency()) turnover"
    }
}
