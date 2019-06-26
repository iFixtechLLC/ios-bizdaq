//
//  ProfileViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 21/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet private var backgroundProfileImageView: UIView!
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var bioLabel: UILabel!
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var viewModel: ProfileViewModel?
    
    // MARK: - Lifecycle
    func attach(to viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    static func instance() -> UINavigationController? {
        guard let instance =  UIStoryboard(name: "Profile", bundle: Bundle.main).instantiateInitialViewController() as? UINavigationController else { return nil }
        return instance
    }
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else { preconditionFailure("viewModel not defined.") }
        bind(to: viewModel)
        setupNavigationBar(isPreview: viewModel.isProfilePreview)
        style()
    }
    
    private func setupNavigationBar(isPreview: Bool) {
        if isPreview {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: Theme.Icons.navigateBackIcon,
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(didPressBackButton))
            navigationItem.rightBarButtonItems = nil
        }
    }
    
    // MARK: - Binding
    func bind(to viewModel: ProfileViewModel) {
        if let imagePath = viewModel.user.publicUser.publicUserProfile?.photoPathToFile {
            ImageCache.setImage(for: profileImageView, pathToFile: imagePath)
        } else {
            profileImageView.image = Theme.Icons.imagePlaceholderIcon
        }
        
        viewModel.profileDataDriver
            .drive(onNext: { [weak self] (data) in
                self?.nameLabel.text = data.name
                self?.bioLabel.text = data.bio
            })
            .disposed(by: bag)
        
        viewModel.imageDriver
            .drive(onNext: { [weak self] (image) in
                self?.profileImageView.image = image
            })
            .disposed(by: bag)
    }
    
    // MARK: - Styling
    private func style() {
        backgroundProfileImageView.layer.cornerRadius = backgroundProfileImageView.frame.width / 2
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        navigationController?.navigationBar.style()
        setStatusBarStyle(.lightContent)
    }
    
    // MARK: - Actions
    @objc func didPressBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressMenuButton(_ sender: Any) {
        Menu.shared.toggle(sender: view.window)
    }
    
    @IBAction func didPressEditButton(_ sender: Any) {
        navigate(to: .editProfile, sender: self)
    }
}

// MARK: - Navigation
extension ProfileViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case editProfile
        case changePassword
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .editProfile:
            guard let user = viewModel?.user else { break }
            guard let destination = segue.destination as? EditProfileViewController else { break }
            destination.attach(to: ViewModelFactory.Profile.makeEditProfileViewModel(user: user))
            destination.profileViewModel = viewModel
        case.changePassword:
            guard segue.destination is ChangePasswordViewController else { break }
            
        }
    }
}
