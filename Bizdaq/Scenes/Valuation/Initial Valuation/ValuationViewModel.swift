//
//  ValuationViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 17/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ValuationViewModel: CanRequestValuations {
    
    // MARK: - Properties
    var apiClient: APIClient
    var authToken: AuthToken?
    var bag = DisposeBag()
    
    private let freeholdKey = "freehold"
    var isFreehold = false
    
    var valuationProperties = ValuationViewModel.InitialValuationProperties()
    struct InitialValuationProperties {
        var sectorId: String?
        var tenure: String?
        var annualTurnover: String?
        var postcode: String?
        var userName: String?
        var emailAddress: String?
        var phoneNumber: String?
        
        func modelComplete() -> Bool {
            return sectorId != nil
                && tenure != nil
                && annualTurnover != nil
                && postcode != nil
                && emailAddress != nil
                && phoneNumber != nil
        }
    }
    
    // MARK: - Lifecycle
    init(apiClient: APIClient,
         authToken: AuthToken?) {
        self.apiClient = apiClient
        self.authToken = authToken
        
        if authToken != nil {
            guard let firstName = UserSession.shared.user?.publicUser.firstName else { return }
            guard let lastName = UserSession.shared.user?.publicUser.lastName else { return }
            setUserName("\(firstName) \(lastName)")
        }
    }
    
    // MARK: - Public Methods
    func setSectorId(_ id: Int) {
        valuationProperties.sectorId = String(id)
    }
    
    func setTenure(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in
            guard let `self` = self else { return }
            if let tenureOptions = DynamicLexicon.PreDefinedChoices.BasicBusinessValuation.tenure {
                let selection = tenureOptions.map({ (k, v) -> String? in
                    if v == value {
                        return k
                    }
                    return nil
                }).filter { $0 != nil }
                self.valuationProperties.tenure = selection.first ?? nil
                self.isFreehold = selection.first == self.freeholdKey
            }
        }).disposed(by: bag)
    }
    
    func setAnnualTurnover(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in
            guard let value = value else { return }
            self?.valuationProperties.annualTurnover = value
        }).disposed(by: bag)
    }
    
    func setPostcode(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.valuationProperties.postcode = value }).disposed(by: bag)
    }
    
    func setUserName(_ username: String) {
        valuationProperties.userName = username
    }
    
    func setEmailAddress(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.valuationProperties.emailAddress = value }).disposed(by: bag)
    }
    
    func setPhoneNumber(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.valuationProperties.phoneNumber = value }).disposed(by: bag)
    }
    func requestValuation(completion: @escaping (CreateBusinessValuationResponse?) -> Void) {
        guard valuationProperties.modelComplete() else { completion(nil); return }
        
        let authToken = UserSession.shared.authToken
        debugPrint("GO GO")
        apiClient.submitValuation(authToken: authToken ?? "",
                                  businessSectorId: valuationProperties.sectorId!,
                                   tenure: valuationProperties.tenure!,
                                   annualTurnover: valuationProperties.annualTurnover!,
                                   businessPostcode: valuationProperties.postcode,
                                   userName: valuationProperties.userName,
                                   emailAddress: valuationProperties.emailAddress,
                                   phoneNumber: valuationProperties.phoneNumber, widgetValues: nil)
            .subscribe(onSuccess: { (response) in
//                completion()
                debugPrint("SUCCESS!")
                debugPrint(response)
                completion(response)
            }, onError: { (error) in
                debugPrint(error)
            })
            .disposed(by: bag)
       
    }

}
