//
//  GalleryCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 14/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class GalleryCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imageGalleryView: ImageGalleryView!
    @IBOutlet weak var isRecommendedView: UIView!
    
    // MARK: - Properties
    private var isRecommended = false {
        didSet { isRecommendedView.isHidden = !isRecommended }
    }
    private var imagePaths: [String]? {
        didSet {
            guard imagePaths != nil else { return }
            imageGalleryView.setImagePaths(imagePaths!)
        }
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        style()
    }
    
    // MARK: - Styling
    private func style() {
        isRecommendedView.style(rounded: true)
        selectionStyle = .none
    }
    
    // MARK: - Public Methods
    func configure(with business: Business) {
        isRecommended = business.isPremiumListing ?? false
        if let photos = business.businessPhotos {
            imagePaths = photos.filter { $0.pathToFile != nil }.map { $0.pathToFile! }
        }
    }
}
