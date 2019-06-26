//
//  RejectedOfferCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 01/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class RejectedOfferCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var offerPriceLabel: UILabel!
    @IBOutlet weak var rejectedDateLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    
    // MARK: - Styling
    private func style() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    // MARK: - Public Methods
    func configure(with model: BusinessEngagementBid) {
        if let publicUser = model.buyerPublicUser {
            guard let firstName = publicUser.firstName else { return }
            guard let lastName = publicUser.lastName else { return }
            nameLabel.text = "\(firstName) \(lastName)"
        }
        if let offeredAmount = model.bidAmount?.toCurrency() {
            offerPriceLabel.text = "Offered: \(offeredAmount)"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        if let rejectedDate = dateFormatter.date(from: model.dateTimeBidReviewed ?? String.empty) {
            rejectedDateLabel.text = "Rejected on: \(rejectedDate.toDateStringRepresentation())"
        }
    }
}
