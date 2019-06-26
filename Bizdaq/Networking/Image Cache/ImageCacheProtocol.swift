//
//  ImageCacheProtocol.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 23/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

protocol ImageCacheProtocol {
    static func setImage(for imageView: UIImageView, pathToFile: String, temporaryImage: UIImage?)
}
