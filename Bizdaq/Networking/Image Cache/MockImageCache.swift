//
//  MockImageCache.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 23/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class MockImageCache: ImageCacheProtocol {
    
    // MARK: - Public Methods
    static func setImage(for imageView: UIImageView, pathToFile: String, temporaryImage: UIImage? = nil) {
        if let image = UIImage(named: Constants.placeholderImageName) {
            imageView.image = image
        }
    }
}
