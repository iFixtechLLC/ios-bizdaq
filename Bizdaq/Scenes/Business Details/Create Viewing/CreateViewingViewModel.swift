//
//  CreateViewingViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 01/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CreateViewingViewModel {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private let apiClient: APIClient
    private let business: Business
    private let businessEngagement: BusinessEngagement
    let popupManager: PopupManager
    
    private var optionOneDateString: String?
    private var optionTwoDateString: String?
    private var optionThreeDateString: String?
    private var optionOneTimeString: String?
    private var optionTwoTimeString: String?
    private var optionThreeTimeString: String?
    
    var name: String { return business.name ?? String.empty }
    var location: String { return business.address?.line1 ?? String.empty }
    
    // MARK: - Lifecylce
    init(apiClient: APIClient, business: Business, engagement: BusinessEngagement, popupManager: PopupManager) {
        self.apiClient = apiClient
        self.business = business
        self.businessEngagement = engagement
        self.popupManager = popupManager
    }
    
    // MARK: - Public Methods
    func createViewing(completion: @escaping (_ success: Bool) -> Void) {
        guard let authToken = UserSession.shared.authToken else { return }
        guard let businessEngagementId = businessEngagement.id else { return }
        guard optionOneDateString != nil
            && optionTwoDateString != nil
            && optionThreeDateString != nil
            && optionOneTimeString != nil
            && optionTwoTimeString != nil
            && optionThreeTimeString != nil
            else { return }
        apiClient.createBusinessEngagementViewing(authToken: authToken,
                                                  businessEngagementId: businessEngagementId,
                                                  dateOption1: optionOneDateString!,
                                                  timeStartOption1: optionOneTimeString!,
                                                  dateOption2: optionTwoDateString!,
                                                  timeStartOption2: optionTwoTimeString!,
                                                  dateOption3: optionThreeDateString!,
                                                  timeStartOption3: optionThreeTimeString!)
            .subscribe(onSuccess: { (response) in
                if let _ = response.data?.businessEngagementViewing {
                    completion(true)
                } else {
                    completion(false)
                }
            }) { (error) in
                completion(false)
            }
            .disposed(by: bag)
    }
    
    func setOptionOneDate(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.optionOneDateString = value } ).disposed(by: bag)
    }
    
    func setOptionTwoDate(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.optionTwoDateString = value } ).disposed(by: bag)
    }
    
    func setOptionThreeDate(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.optionThreeDateString = value } ).disposed(by: bag)
    }
    
    func setOptionOneTime(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.optionOneTimeString = value } ).disposed(by: bag)
    }
    
    func setOptionTwoTime(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.optionTwoTimeString = value } ).disposed(by: bag)
    }
    
    func setOptionThreeTime(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.optionThreeTimeString = value } ).disposed(by: bag)
    }
}
