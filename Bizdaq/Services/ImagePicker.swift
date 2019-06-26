//
//  ImagePicker.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 25/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class ImagePicker {
    
    func presentPicker(from viewController: UIViewController) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let imagePickerView = UIImagePickerController()
        imagePickerView.sourceType = .photoLibrary
        //imagePickerView.delegate = self
        
        guard let navigationController = viewController.navigationController else { return }
        navigationController.present(imagePickerView, animated: true, completion: nil)
    }
}
