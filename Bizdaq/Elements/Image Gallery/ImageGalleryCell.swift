//
//  ImageGalleryCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 25/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

final class ImageGalleryCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Public Methods
    func configure(imagePath: String) {
        ImageCache.setImage(for: imageView, pathToFile: imagePath, temporaryImage: UIImage(named: Constants.placeholderImageName))
    }
}
