//
//  AdvertCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 06/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class AdvertCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var engagementsButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var marketingButton: UIButton!
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var engagementCountBackground: UIView!
    @IBOutlet weak var engagementCountLabel: UILabel!
    @IBOutlet weak var backgroundCardView: UIView!
    
    // MARK: - Properties
    private var engagementsButtonHandler: (() -> Void)?
    private var editButtonHandler: (() -> Void)?
    private var marketingButtonHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        style()
    }
    
    // MARK: - Styling
    private func style() {
        engagementsButton.style(rounded: true)
        backgroundCardView.style(rounded: true)
        editButton.style(rounded: true)
        engagementCountBackground.style(rounded: true, radius: engagementCountBackground.bounds.height/2)
        
        heroImageView.layoutIfNeeded()
        let roundedPath = UIBezierPath(roundedRect: heroImageView.bounds,
                                       byRoundingCorners: [.topLeft, .topRight],
                                       cornerRadii: CGSize(width: 3, height: 3))
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundedPath.cgPath
        heroImageView.layer.mask = maskLayer
        selectionStyle = .none
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

        if let description = business.advertHeadline {
            descriptionLabel.text = description
        }
        
        if let engagementCount = business.enquiryCount {
            engagementCountLabel.text = "\(engagementCount)"
            engagementCountBackground.isHidden = engagementCount <= 0
            engagementCountLabel.isHidden = engagementCount <= 0
        }
    }
    
    func setEngagementButtonHandler(_ handler: @escaping () -> Void) {
        engagementsButtonHandler = handler
    }
    
    func setEditButtonHandler(_ handler: @escaping () -> Void) {
        editButtonHandler = handler
    }
    
    func setMarketingButtonHandler(_ handler: @escaping () -> Void) {
        marketingButtonHandler = handler
    }
    
    // MARK: - Actions
    @IBAction func didPressEngagementsButton(_ sender: UIButton) {
        engagementsButtonHandler?()
    }
    
    @IBAction func didPressEditButton(_ sender: UIButton) {
        editButtonHandler?()
    }
    
    @IBAction func didPressMarketingButton(_ sender: UIButton) {
        marketingButtonHandler?()
    }
}
