//
//  MarketingViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 08/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MarketingViewModel: CanEditBusinessAddress, CanGetBusinessPromoEmails {
    
    // MARK: - Properties
    let bag = DisposeBag()
    let apiClient: APIClient
    let authToken: AuthToken
    let business: Business
    
    var businessAddress: BusinessAddress? {
        return business.address
    }
    
    private var addressLine1: String?
    private var addressLine2: String?
    private var addressLine3: String?
    private var townCity: String?
    private var postcode: String?
    
    // MARK: - Lifecycle
    init(apiClient: APIClient, authToken: AuthToken, business: Business) {
        self.apiClient = apiClient
        self.authToken = authToken
        self.business = business
        setup(with: business)
    }
    
    // MARK: - Private Methods
    private func setup(with model: Business) {
        addressLine1 = model.address?.line1
        addressLine2 = model.address?.line2
        addressLine3 = model.address?.line3
        townCity = model.address?.townCity
        postcode = model.address?.postcode
    }
    
    // MARK: - Public Methods
    func setAddressLine1(_ driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.addressLine1 = value }).disposed(by: bag)
    }
    
    func setAddressLine2(_ driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.addressLine2 = value }).disposed(by: bag)
    }
    
    func setAddressLine3(_ driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.addressLine3 = value }).disposed(by: bag)
    }
    
    func setTownCity(_ driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.townCity = value }).disposed(by: bag)
    }
    
    func setPostcode(_ driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.postcode = value }).disposed(by: bag)
    }
    
    func saveChanges(completion: @escaping (_ success: Bool) -> Void) {
        guard let businessId = business.id else { return }
        editBusinessAddress(businessId: businessId,
                            line1: addressLine1,
                            line2: addressLine2,
                            line3: addressLine3,
                            townCity: townCity,
                            postcode: postcode) { (response) in
            switch response {
            case .success(_):
                completion(true)
            case .error(_):
                completion(false)
            }
        }
    }
    
    func getBusinessPromoEmails(_ completion: @escaping (_ response: Response<[PromoEmails]>?) -> Void) {
        if let businessId = business.id {
            getBusinessPromoEmails(businessId: businessId, completion: completion)
        } else { completion(nil) }
    }
}
