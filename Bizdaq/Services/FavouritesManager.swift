//
//  FavouritesManager.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 05/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FavouritesManager {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private let apiClient: APIClient
    
    // MARK: - Lifecycle
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public Methods
    func addFavourite(businessId: Int, completionHandler: ((_ success: Bool) -> Void)? = nil) {
        guard let authToken = UserSession.shared.authToken else { return }
        apiClient.toggleSavedBusiness(authToken: authToken, businessId: businessId, isToBeSaved: true)
            .subscribe(onSuccess: { (response) in
                completionHandler?(true)
            }) { (error) in
                completionHandler?(false)
            }
            .disposed(by: bag)
    }
    
    func removeFavourite(businessId: Int, businessName: String, completionHandler: ((_ success: Bool) -> Void)? = nil) {
        guard let authToken = UserSession.shared.authToken else { completionHandler?(false); return }
        let confirmationPopup = UnfavouriteConfirmationPopup(removeButtonHandler: { [weak self, weak bag] in
            guard let bag = bag else { return }
            Popup.shared.dismiss()
            self?.apiClient.toggleSavedBusiness(authToken: authToken, businessId: businessId, isToBeSaved: false)
                .subscribe(onSuccess: { (response) in
                    completionHandler?(true)
                }, onError: { (error) in
                    completionHandler?(false)
                })
                .disposed(by: bag)
        }) {
            completionHandler?(false)
        }
        confirmationPopup.setName(businessName)
        Popup.shared.setPopupView(confirmationPopup)
        Popup.shared.present()
    }
}
