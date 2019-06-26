//
//  SellersStatsCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 11/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class SellersStatsCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var enquiriesCountLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var viewingsCountLabel: UILabel!
    @IBOutlet weak var offerCountLabel: UILabel!
    @IBOutlet weak var enquiriesCountBorder: UIView!
    @IBOutlet weak var viewsCountBorder: UIView!
    @IBOutlet weak var viewingsCountBorder: UIView!
    @IBOutlet weak var offerCountBorder: UIView!
    
    // MARK: - Properties
    static let cellHeight: CGFloat = 222
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    
    // MARK: - Styling
    private func style() {
        styleCountBorders()
        selectionStyle = .none
    }
    
    // MARK: - Private Methods
    private func styleCountBorders() {
        enquiriesCountBorder.style(borderWidth: 2.0, borderColor: UIColor(hex: "D3E8F9"), rounded: true)
        viewsCountBorder.style(borderWidth: 2.0, borderColor: UIColor(hex: "D3E8F9"), rounded: true)
        viewingsCountBorder.style(borderWidth: 2.0, borderColor: UIColor(hex: "D3E8F9"), rounded: true)
        offerCountBorder.style(borderWidth: 2.0, borderColor: UIColor(hex: "D3E8F9"), rounded: true)
    }
    
    // MARK: - Public Methods
    func configure(with profile: PublicUserSellerProfile) {
        enquiriesCountLabel.text = "\(profile.enquiryCount)"
        viewsCountLabel.text = "\(profile.viewsCount)"
        viewingsCountLabel.text = "\(profile.viewingCount)"
        offerCountLabel.text = "\(profile.offerCount)"
    }
}
