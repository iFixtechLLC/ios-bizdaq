//
//  ImageCache.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 23/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import Kingfisher

class ImageCache: ImageCacheProtocol {
    
    // MARK: - Public Methods
    static func setImage(for imageView: UIImageView, pathToFile: String, temporaryImage: UIImage? = nil) {
        let url = URL(string: Constants.Networking.imageServerURL + pathToFile)
        debugPrint("URL set image:")
        debugPrint(url)
        if(Constants.Networking.development){
            let modifier = AnyModifier { request in
                var r = request
                r.setValue("Basic Yml6ZGFxOmxldG1laW5iaXpkYXE=", forHTTPHeaderField: "Authorization")
                return r
            }
            guard let temporaryImage = temporaryImage else { imageView.kf.setImage(with: url, options: [.requestModifier(modifier)]); return }
            debugPrint("development temp image")
            imageView.kf.setImage(with: url, placeholder: temporaryImage, options: [.requestModifier(modifier)])
        }
        
        
        guard let temporaryImage = temporaryImage else { imageView.kf.setImage(with: url); return }
        debugPrint("temp image")
        imageView.kf.setImage(with: url, placeholder: temporaryImage)
        
    }
    
    static func getUIImageFromPath(path: String, defaultUIImage: UIImage) -> UIImage? {
        let url = URL(string: Constants.Networking.imageServerURL + path)
        let modifier = AnyModifier { request in
            var r = request
            r.setValue("Basic Yml6ZGFxOmxldG1laW5iaXpkYXE=", forHTTPHeaderField: "Authorization")
            return r
        }
        var gotImage:UIImage?
        KingfisherManager.shared.retrieveImage(with: url!, options: [.requestModifier(modifier)], progressBlock: nil) { image, error, cacheType, imageURL in
            if(image != nil ){
                gotImage = image
            }else{
                debugPrint(error)
            }
        }
        return gotImage
    }
}
