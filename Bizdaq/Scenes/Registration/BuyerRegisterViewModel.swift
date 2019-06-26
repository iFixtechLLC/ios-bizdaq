//
//  BuyerRegisterViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 17/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class BuyerRegisterViewModel: RegisterViewModel {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    var hearAboutUs: String?
    var sectorIds: [String]?
    
    var hearAboutUsOptions: [String] {
        return getHearAboutUsStrings()
    }
    
    var businessSectorOptions: [String] {
        return getBusinessSectorStrings()
    }
    
    // MARK: - Private Methods
    private func getHearAboutUsStrings() -> [String] {
        guard var howDidYouHearAboutUsChoices = DynamicLexicon.PreDefinedChoices.PublicUser.howDidYouHearAboutUs else { return [String]() }
        var array = Array(howDidYouHearAboutUsChoices.values)
        array.insert(Lexicon.Registration.noValuePlaceholder, at: 0)
        return array
    }
    
    private func getBusinessSectorStrings() -> [String] {
        guard let businessSectors = DynamicLexicon.Business.sectors else { return [String]() }
        return businessSectors.filter { $0.name != nil }.map { $0.name! }
    }
    
    private func getBusinessSectorIds() -> [Int] {
        guard let businessSectors = DynamicLexicon.Business.sectors else { return [Int]() }
        return businessSectors.filter { $0.id != nil }.map { $0.id! }
    }
    
    // MARK: - Public Methods
    func setHearAboutUs(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.hearAboutUs = value }).disposed(by: bag)
    }
    
    func setSectorIds(driver: Driver<[Int]?>) {
        driver.map({ (values) -> [String]? in
            if values != nil {
                let sectorIds = self.getBusinessSectorIds()
                var array = [String]()
                values!.forEach({ (value) in
                    array.append("\(sectorIds[value])")
                })
                if array.isEmpty { return nil } else { return array }
            } else {
                return nil
            }
        })
            .drive(onNext: { [weak self] (values) in self?.sectorIds = values })
            .disposed(by: bag)
    }
    
    func registerAccount(success: @escaping (Bool, Error?) -> Void) {
        guard allFieldsValid else { success(false, nil); return }
        apiClient.registerBuyer(firstName: firstName!,
                                lastName: lastName!,
                                mobilePhone: mobile!,
                                emailAddress: email!,
                                password: password!,
                                howDidYouHearAboutUs: hearAboutUs,
                                businessSectorsOfInterest: sectorIds)
            .subscribe(onSuccess: { (response) in
                UserSession.shared.setActiveUser(response.data.user)
                success(true, nil)
            }) { (error) in
                success(false, error)
            }
            .disposed(by: bag)
    }
}
