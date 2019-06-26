//
//  PendingOfferCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 01/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class PendingOfferCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var askingPriceLabel: UILabel!
    @IBOutlet weak var offerPriceLabel: UILabel!
    @IBOutlet weak var viewOfferButton: UIButton!
    @IBOutlet weak var backgroundCardView: UIView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    
    // MARK: - Styling
    private func style() {
        businessImageView.style(rounded: true)
        backgroundCardView.style(borderWidth: 1.0, borderColor: Theme.UIElements.lightBlueBorderColor, rounded: true)
        viewOfferButton.style(rounded: true)
    }
    
    // MARK: - Public Methods
    func configure(with model: BusinessEngagementBid) {
        nameLabel.text = model.business?.advertHeadline ?? "N/A"
        if let offeredAmount = model.bidAmount?.toCurrency() {
            offerPriceLabel.text = "Offered: \(offeredAmount)"
        }
        if let askingPrice = model.business?.askingPrice?.toCurrency() {
            askingPriceLabel.text = "Asking: \(askingPrice)"
        }
        if let heroImage = model.business?.businessPhotos?.first {
            guard let pathToFile = heroImage.pathToFile else { return }
            ImageCache.setImage(for: businessImageView, pathToFile: pathToFile, temporaryImage: Theme.Icons.imagePlaceholderIcon)
        }
    }
}

