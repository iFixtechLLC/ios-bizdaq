//
//  DashboardCollectionCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 07/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class DashboardCollectionCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    static let cellWidth: CGFloat = 242
    static let cellHeight: CGFloat = 241
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        style()
    }
    
    // MARK: - Styling
    private func style() {
        backgroundCardView.style(rounded: true)
        let roundedPath = UIBezierPath(roundedRect: heroImageView.bounds,
                                       byRoundingCorners: [.topLeft, .topRight],
                                       cornerRadii: CGSize(width: 3, height: 3))
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundedPath.cgPath
        heroImageView.layer.mask = maskLayer
    }
    
    // MARK: - Public Methods
    func configure(for business: Business) {
        if let pathToPrimaryPhotoFile = business.businessPhotos?.first?.pathToFile {
            ImageCache.setImage(for: heroImageView, pathToFile: pathToPrimaryPhotoFile, temporaryImage: UIImage(named: Constants.placeholderImageName))
        } else {
            heroImageView.image = UIImage(named: Constants.placeholderImageName)
        }
        
        if let askingPrice = business.askingPrice {
            priceLabel.text = askingPrice.toCurrency()
        }
        
        if let description = business.opportunity {
            descriptionLabel.text = description
        }
    }
}
