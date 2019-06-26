//
//  ProfileViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 21/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewModel {
    
    // MARK: - Properties
    var user: User {
        didSet {
            updateData(with: user)
        }
    }
    var isProfilePreview: Bool
    
    private let imageSubject = BehaviorSubject<UIImage>(value: Theme.Icons.avatarPlaceholderIcon ?? UIImage())
    var imageDriver: Driver<UIImage> { return imageSubject.asDriver(onErrorJustReturn: Theme.Icons.imagePlaceholderIcon ?? UIImage())}
    
    struct ProfileData {
        let name: String
        let bio: String
    }
    private let profileDataSubject = BehaviorRelay<ProfileData>(value: ProfileData(name: String.empty, bio: String.empty))
    var profileDataDriver: Driver<ProfileData> {
        return profileDataSubject.asDriver(onErrorJustReturn: ProfileData(name: String.empty, bio: String.empty))
    }
    
    // MARK: - Lifecycle
    init(user: User, profileImage: UIImage? = nil, isProfilePreview: Bool = false) {
        self.user = user
        self.isProfilePreview = isProfilePreview
        if profileImage != nil {
            imageSubject.onNext(profileImage!)
        }
        updateData(with: user)
    }
    
    // MARK: - Private Methods
    private func updateData(with model: User) {
        let profileData = ProfileData(name: "\(user.publicUser.firstName) \(user.publicUser.lastName)",
                                      bio: user.publicUser.publicUserProfile?.bio ?? "")
        profileDataSubject.accept(profileData)
    }
    
    // MARK: - Public Methods
    func setProfileImage(_ image: UIImage?) {
        if let image = image {
            imageSubject.onNext(image)
        }
    }
}
