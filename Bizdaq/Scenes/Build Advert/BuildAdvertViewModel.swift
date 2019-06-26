//
//  BuildAdvertViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 20/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BuildAdvertViewModel {
    
    // MARK: - Properties
    let bag = DisposeBag()
    let apiClient: APIProtocol
    let isModal: Bool
    
    let sectorOptions = DynamicLexicon.Business.sectors
    var advertParameters = AdvertParameters()
    
    var businessId: Int?
    
    init(apiClient: APIProtocol, advertParameters: AdvertParameters?, isModal: Bool) {
        self.apiClient = apiClient
        if advertParameters != nil { self.advertParameters = advertParameters! }
        self.isModal = isModal
    }
    
    // MARK: - Private Methods
    private func sectorIdFor(sectorName: String) -> Int? {
        return sectorOptions?.filter { $0.name == sectorName }.first?.id
    }
    
    // MARK: - Public Methods
    func setTenure(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in
            self?.advertParameters.tenure = DynamicLexicon.getKeyByValue(array: DynamicLexicon.PreDefinedChoices.Business.tenure, value: value)
//            if let tenureOptions = DynamicLexicon.PreDefinedChoices.Business.tenure {
//                let selection = tenureOptions.map({ (k, v) -> String? in
//                    if v == value {
//                        return k
//                    }
//                    return nil
//                }).filter { $0 != nil }
//                self?.advertParameters.tenure = selection.first ?? nil
//            }
        }).disposed(by: bag)
    }
    
    func setBusinessSector(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in
            guard let value = value else { return }
            self?.advertParameters.businessSectorId = self?.sectorIdFor(sectorName: value)
        }).disposed(by: bag)
    }
    
    func setPostcode(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in
            self?.advertParameters.postcode = value
        }).disposed(by: bag)
    }
    
    func setAnnualTurnover(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in
            guard let value = value else { return }
            self?.advertParameters.annualTurnover = Int(Double(value) ?? 0)
        }).disposed(by: bag)
    }
    
    func setNetProfit(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in
            guard let value = value else { return }
            self?.advertParameters.netProfit = Int(Double(value) ?? 0)
        }).disposed(by: bag)
    }
    
    func setHasStaff(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in
            guard let value = value else { return }
            guard (DynamicLexicon.PreDefinedChoices.Business.hasStaff?["yes"]) != nil else { preconditionFailure("'yes' key has been removed from the Lexicon (sever-side)") }
            self?.advertParameters.hasStaff = DynamicLexicon.getKeyByValue(array: DynamicLexicon.PreDefinedChoices.Business.hasStaff, value: value)
        }).disposed(by: bag)
    }
    
    func setHasAccommodation(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in
            guard let value = value else { return }
            self?.advertParameters.propertyHasAccommodaton = DynamicLexicon.getKeyByValue(array: DynamicLexicon.PreDefinedChoices.Business.propertyHasAccomodation, value: value)
        }).disposed(by: bag)
    }
    
    func setYearEstablished(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in
            guard let value = value else { return }
            self?.advertParameters.yearBusinessEstablished = Int(value)
        }).disposed(by: bag)
    }
    
    func setAskingPrice(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in
            guard let value = value else { return }
            self?.advertParameters.askingPrice = Int(value)
        }).disposed(by: bag)
    }
    
    func setOpenToOffers(_ openToOffers: Bool) {
        advertParameters.isOpenToOffers = openToOffers
    }
    
    func setHeadline(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in
            guard let value = value else { return }
            self?.advertParameters.advertHeadline = value
        }).disposed(by: bag)
    }
    
    func setBusinessBriefDescription(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in
            guard let value = value else { return }
            self?.advertParameters.opportunity = value
        }).disposed(by: bag)
    }
    
    func setBusinessDescription(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in
            guard let value = value else { return }
            self?.advertParameters.property = value
        }).disposed(by: bag)
    }
    
    func createAdvert(completion: @escaping (_ success: Bool) -> Void) {
        guard let authToken = UserSession.shared.authToken else { return }
        if (advertParameters.netProfit ?? 0) < 1 {
            PopupManager().presentSimplePopup(then: {}, title: "Validation Error", description: "Net profit has to be a positive integer")
            return
        }
        
        if (advertParameters.annualTurnover ?? 0) < 1 {
            PopupManager().presentSimplePopup(then: {}, title: "Validation Error", description: "Annual Turnover has to be a positive integer")
            return
        }
        
        if advertParameters.advertHeadline == nil {
            PopupManager().presentSimplePopup(then: {}, title: "Validation Error", description: "Headline must be valid")
            return
        }
        
        if advertParameters.tenure == nil {
            PopupManager().presentSimplePopup(then: {}, title: "Validation Error", description: "Tenure must be valid")
            return
        }
        
        //edit or create functionality is within apiclient
        apiClient.createAdvert(authToken: authToken, advert: advertParameters)
            .subscribe(onSuccess: { (response) in
                guard let businessId = response.data?.business?.id else {
                    completion(false)
                    return
                }
                self.businessId = businessId
                completion(true)
            }) { (error) in
                debugPrint("Error:"+String(describing:error))
                completion(false)
            }
            .disposed(by: bag)
    }
}
