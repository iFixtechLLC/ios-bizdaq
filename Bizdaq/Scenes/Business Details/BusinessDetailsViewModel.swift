//
//  BusinessDetailsViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 14/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BusinessDetailsViewModel {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private let apiClient: APIClient
    private let authToken: AuthToken?
    private let favouritesManager: FavouritesManager
    private let engagementManager: BusinessEngagementManager
    private let popupManager: PopupManager
    var business: Business
    
    let businessEngagementSubject = BehaviorRelay<BusinessEngagement?>(value: nil)
    var businessEngagementDriver: Driver<BusinessEngagement?> { return businessEngagementSubject.asDriver(onErrorJustReturn: nil)}
    var businessEngagement: BusinessEngagement? { return businessEngagementSubject.value }
    
    var isFavourited: Bool { return business.isSaved ?? false }
    
    // MARK: - Lifecycle
    init(apiClient: APIClient,
         authToken: AuthToken?,
         engagementManager: BusinessEngagementManager,
         favouritesManager: FavouritesManager,
         popupManager: PopupManager,
         business: Business) {
        self.apiClient = apiClient
        self.authToken = authToken
        self.engagementManager = BusinessEngagementManager(apiClient: apiClient)
        self.favouritesManager = favouritesManager
        self.popupManager = popupManager
        self.business = business
    }
    
    // MARK: - Private Methods
    func getEngagement(completion: @escaping (_ engagement: BusinessEngagement?) -> Void) {
        guard let businessId = business.id else { completion(nil); return }
        engagementManager.getEngagement(for: UserSession.shared, businessId: businessId) { (businessEngagement) in
            guard let engagement = businessEngagement else { completion(nil); return }
            completion(engagement)
        }
    }
    
    // MARK: - Public Methods
    func favourite(businessId: Int, completionHandler: @escaping (_ success: Bool) -> Void) {
        favouritesManager.addFavourite(businessId: businessId) { [weak self] (success) in
            if success { self?.business.isSaved = true }
            completionHandler(success)
        }
    }
    
    func unfavourite(businessId: Int, completionHandler: @escaping (_ success: Bool) -> Void) {
        let name = business.name ?? Lexicon.BusinessDetail.noValue
        favouritesManager.removeFavourite(businessId: businessId, businessName: name) { [weak self] (success) in
            if success { self?.business.isSaved = false }
            completionHandler(success)
        }
    }
    
    func createEngagement(completion: @escaping (_ created: Bool) -> Void) {
        guard UserSession.shared.isLoggedIn else { completion(false); return }
        guard businessEngagementSubject.value == nil else { completion(false); return }
        guard let businessId = business.id else { completion(false); return }
        
        engagementManager.getEngagement(for: UserSession.shared, businessId: businessId) { [weak self] (businessEngagement) in
            guard businessEngagement == nil else { completion(false); return }
            
            self?.popupManager.presentMessagePopup(then: { [weak self] (message) in
                self?.engagementManager.createEngagement(userSession: UserSession.shared, businessId: businessId, message: message) { [weak self] (businessEngagement) in
                    guard let businessEngagement = businessEngagement else { completion(false); return }
                    self?.businessEngagementSubject.accept(businessEngagement)
                    completion(true)
                }
            })
        }
    }
    
    func updateBusinessEngagement() {
        getEngagement { [weak self] (engagement) in
            self?.businessEngagementSubject.accept(engagement)
        }
    }
    
    func showRequestViewing(){
        popupManager.presentRequestViewingPopup(dismissHandler: {}, apiClient: apiClient, authToken: authToken, businessEngagementId: businessEngagement?.id)
    }
    
    func showMakeOffer(){
        popupManager.presentMakeOfferPopup(dismissHandler: {}, apiClient: apiClient, authToken: authToken, businessEngagementId: businessEngagement?.id)
    }
    func showRequestDocument(){
        popupManager.presentRequestDocPopup(dismissHandler: {}, apiClient: apiClient, authToken: authToken, businessEngagementId: businessEngagement?.id)
    }
    //No longer required
    func withdrawEngagement(){
//        guard let bId = businessEngagement?.id else {
//            popupManager.presentSimplePopup(then: {}, title: "Error", description: "Can't do that at this time")
//            return }
        //apiClient.reviewEngagement(authToken: authToken!, businessEngagementId: bId, action: "withdraw")
        
    }
    
}
