//
//  EditProfileViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 26/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import JGProgressHUD

class EditProfileViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var firstNameTextField: ValidatedTextField!
    @IBOutlet weak var lastNameTextField: ValidatedTextField!
    @IBOutlet weak var emailTextField: ValidatedTextField!
    @IBOutlet weak var mobileTextField: ValidatedTextField!
    @IBOutlet weak var aboutYourselfTextView: ValidatedTextView!
    @IBOutlet weak var professionalBackgroundTextField: ValidatedTextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var deleteImageView: UIImageView!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    
    // MARK: - Properties
    private var viewModel: EditProfileViewModel?
    weak var profileViewModel: ProfileViewModel?
    var interests: [InterestTypes]?
    private let progressHUD = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    func attach(to viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        progressHUD.parallaxMode = .alwaysOff

        guard let viewModel = viewModel else { preconditionFailure("viewModel not defined.") }
        bind(to: viewModel)
        style()
    }
    
    // MARK: - Styling
    private func style() {
        previewButton.style(rounded: true)
        doneButton.style(rounded: true)
        uploadButton.style(rounded: true)
        profileImageView.style(rounded: true)
    }
    
    // MARK: - Binding
    func bind(to viewModel: EditProfileViewModel) {
        setProfileImage(path: viewModel.profileImagePath)
        
        prepopulate(with: viewModel)
        
        viewModel.setFirstName(driver: firstNameTextField.valueDriver)
        viewModel.setLastName(driver: lastNameTextField.valueDriver)
        viewModel.setEmail(driver: emailTextField.valueDriver)
        viewModel.setMobile(driver: mobileTextField.valueDriver)
        viewModel.setAboutYourself(driver: aboutYourselfTextView.valueDriver)
        viewModel.setProfessionalBackground(driver: professionalBackgroundTextField.valueDriver)
    }
    
    private func prepopulate(with viewModel: EditProfileViewModel) {
        firstNameTextField.setText(viewModel.firstName)
        lastNameTextField.setText(viewModel.lastName)
        emailTextField.setText(viewModel.email)
        mobileTextField.setText(viewModel.mobile)
        aboutYourselfTextView.setText(viewModel.aboutYourself)
    }
    
    // MARK: - Private Methods
    private func setProfileImage(path: String?) {
        if let path = path {
            ImageCache.setImage(for: profileImageView, pathToFile: path, temporaryImage: UIImage(named: "placeholder"))
        } else {
            profileImageView.image = nil
        }
        uploadButton.isHidden = path != nil
    }
    
    private func setProfileImage(image: UIImage) {
        profileImageView.image = image
        uploadButton.isHidden = true
    }
    
    // MARK: - Actions
    @IBAction func didPressBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressPreviewButton(_ sender: UIButton) {
        guard let user = viewModel?.previewModel() else { return }
        if let viewController = UIStoryboard(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "Profile") as? ProfileViewController {
            viewController.attach(to: ViewModelFactory.Profile.makeProfileViewModel(user: user,
                                                                                    profileImage: profileImageView.image,
                                                                                    isProfilePreview: true))
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func didPressSubmitButton(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        progressHUD.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        progressHUD.show(in: view, animated: true)
        
        viewModel.updateProfile(self.profileImageView.image, completion: { [weak self] in
                guard let `self` = self else { return }
                self.progressHUD.dismiss()
                self.profileViewModel?.user = viewModel.user
                if let image = self.profileImageView.image {
                    self.profileViewModel?.setProfileImage(image)
                } else {
                    self.profileViewModel?.setProfileImage(Theme.Icons.imagePlaceholderIcon)
                }
                self.navigationController?.popViewController(animated: true)
            })
    }
    
    @IBAction func didPressUploadButton(_ sender: UIButton) {
        let pickerView = UIImagePickerController()
        pickerView.delegate = self
        pickerView.sourceType = .photoLibrary
        navigationController?.present(pickerView, animated: true, completion: nil)
    }
    
    @IBAction func didPressRemoveButton(_ sender: UIButton) {
        setProfileImage(path: nil)
    }
}

// MARK: - Image Picker Delegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            setProfileImage(image: image)
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - Navigation
extension EditProfileViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case editUserInterests
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .editUserInterests:
            guard let destination  = segue.destination as? UserInterestsViewController else { return }
            destination.attach(to: ViewModelFactory.Profile.makeUserInterestsViewModel(selectionHandler: { [weak self] (interests) in
                self?.viewModel?.interest_types = interests
                self?.viewModel?.updateProfile(nil, completion: { [weak self] in
                    PopupManager().presentSimplePopup(then: {}, title: "Interests Updated", description: "")
                    
                })
                debugPrint(interests)
            }))
        }
    }
}
