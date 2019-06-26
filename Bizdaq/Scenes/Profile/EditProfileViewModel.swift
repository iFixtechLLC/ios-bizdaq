//
//  EditProfileViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 26/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditProfileViewModel {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private let apiClient: APIClient
    var user: User
    
    var firstName: String?
    var lastName: String?
    var email: String?
    var mobile: String?
    var aboutYourself: String?
    var professionalBackground: String?
    var type: String?
    var location: String?
    var interest_types: Array<InterestTypes>

    
    
    var profileImagePath: String? {
        return user.publicUser.publicUserProfile?.photoPathToFile
    }
    
    // MARK: - Lifecycle
    init(apiClient: APIClient, user: User) {
        self.apiClient = apiClient
        self.user = user
        self.interest_types = Array<InterestTypes>()
        configure(with: user)
        guard let types = user.publicUser.publicUserBuyerProfile?.publicUserInterestTypes else{
            return
        }
        self.interest_types = types
        //user.publicUser.publicUserBuyerProfile?.publicUserInterestTypes.map( it:InterestTypes => it)
    }
    
    // MARK: - Private Methods
    private func configure(with model: User) {
        firstName = model.publicUser.firstName
        lastName = model.publicUser.lastName
        email = model.publicUser.email
        mobile = model.publicUser.mobilePhone
        aboutYourself = model.publicUser.publicUserProfile?.bio
    }
    
    // MARK: - Public Methods
    func setFirstName(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.firstName = value }).disposed(by: bag)
    }
    
    func setLastName(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.lastName = value }).disposed(by: bag)
    }
    
    func setEmail(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.email = value }).disposed(by: bag)
    }
    
    func setMobile(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.mobile = value }).disposed(by: bag)
    }
    
    func setAboutYourself(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.aboutYourself = value }).disposed(by: bag)
    }
    
    func setProfessionalBackground(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.professionalBackground = value }).disposed(by: bag)
    }
    
    func setType(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.type = value }).disposed(by: bag)
    }
    
    func setLocation(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.location = value }).disposed(by: bag)
    }
 //   func setInterestTypes(driver: Driver<[InterestTypes]?>) {
 //       driver.drive(onNext: { [weak self] (value) in self?.interest_types = value! }).disposed(by: bag)
 //   }
    
    func updateProfile(_ image: UIImage?, completion: @escaping () -> Void) {
        guard let authToken = UserSession.shared.authToken else { return }
        debugPrint(interest_types)
        apiClient.editProfile(authToken: authToken,
                              firstName: firstName,
                              lastName: lastName,
                              email: email,
                              mobileNumber: mobile,
                              bio: aboutYourself,
                              aboutProfession: professionalBackground,
                              location: location,
                              isPostContactOptedIn: nil,
                              isEmailContactOptedIn: nil,
                              isSmsContactOptedIn: nil,
                              isPhoneContactOptedIn:  nil,
                              interest_types: interest_types,
                              image: image)
            .subscribe(onSuccess: { [weak self] (response) in
                self?.user = response.data.user
                UserSession.shared.setActiveUser(response.data.user)
                completion()
            }) { (error) in
                completion()
            }
            .disposed(by: bag)
    }
    
    func updateProfileImage(_ image: UIImage?, completion: @escaping () -> Void) {
        guard let authToken = UserSession.shared.authToken else { return }
        apiClient.editProfileImage(authToken: authToken, image: image)
            .subscribe(onSuccess: { [weak self] (response) in
                self?.user = response.data.user
                UserSession.shared.setActiveUser(response.data.user)
                completion()
            }) { (error) in
                completion()
            }
            .disposed(by: bag)
    }
    
    func previewModel() -> User {
        var user = self.user
        user.publicUser.firstName = firstName ?? String.empty
        user.publicUser.lastName = lastName ?? String.empty
        user.publicUser.email = email ?? String.empty
        user.publicUser.mobilePhone = mobile ?? String.empty
        user.publicUser.publicUserProfile?.bio = aboutYourself ?? String.empty
        return user
    }
}
