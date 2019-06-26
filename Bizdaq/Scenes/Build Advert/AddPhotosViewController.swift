//
//  AddPhotosViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 21/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class AddPhotosViewController: UIViewController, Modelled {
    
    // MARK: - Outlets
    @IBOutlet weak var laterButton: UIButton!
    @IBOutlet weak var choosePlanButton: UIButton!
    @IBOutlet var iconViews: [UIImageView]!
    @IBOutlet var imageViews: [UIImageView]!
    
    // MARK: - Properties
    private var viewModel: AddPhotosViewModel?
    var selectedImageView: Int?
    
    // MARK: - Lifecycle
    func attach(to viewModel: AddPhotosViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard viewModel != nil else { preconditionFailure("viewModel not defined.")}
        style()
    }
    
    // MARK: - Styling
    private func style() {
        laterButton.style(borderWidth: 1.0, borderColor: Theme.UIElements.defaultBorderColor, rounded: true)
        choosePlanButton.style(rounded: true)
        imageViews.forEach { $0.style(rounded: true) }
    }

    // MARK: - Actions
    @IBAction func didPressBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressUploadButton(_ sender: UIButton) {
        selectedImageView = sender.tag
        let pickerView = UIImagePickerController()
        pickerView.delegate = self
        pickerView.sourceType = .photoLibrary
        navigationController?.present(pickerView, animated: true, completion: nil)
    }
    
    @IBAction func didPressSubmitButton(_ sender: UIButton) {
        let images = imageViews.filter { $0.image != nil }.map { $0.image! }
        viewModel?.uploadPhotos(images: images, completion: { (success) in
            let pum = PopupManager()
            if success {
                pum.presentSimplePopup(then: {
                    Menu.shared.reintialise(sender: self.view.window)
                    Menu.shared.menuView?.setSellerDashboardAsRoot()
                }, title: "Success", description: "You uploaded \(images.count) photos of your business")
            }else{
                pum.presentSimplePopup(then: {
                    Menu.shared.reintialise(sender: self.view.window)
                    Menu.shared.menuView?.setSellerDashboardAsRoot()
                }, title: "Error", description: "Can't upload images at this time")
            }
        })
    }
    @IBAction func didPressLaterButton(_ sender: Any) {
        //WHEN window is nil
        Menu.shared.reintialise(sender: self.view.window)
        Menu.shared.menuView?.setSellerDashboardAsRoot()
        
    }
}

// MARK: - Image Picker Delegate
extension AddPhotosViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImageView = selectedImageView else { return }
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageViews[selectedImageView].image = image
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}
